//
//  CThreadController.m
//  xSpace
//
//  Created by JSK on 2018/3/19.
//  Copyright © 2018年 xSpace. All rights reserved.
//

#import "CThreadController.h"
#include <pthread.h>
#include <stdio.h>

typedef struct MyPacket{
    int value;
} MyPacket;

typedef struct MyPacketList {
    MyPacket pkt;
    struct MyPacketList *next;
} MyPacketList;

typedef struct PacketQueue {
    MyPacketList    *first_pkt, *last_pkt;
    int             nb_packets;
    int             size;
    int             shouldQuit;
    pthread_mutex_t mutex;
    pthread_cond_t  cond;
} PacketQueue;


void packet_queue_init(PacketQueue *q) {
    memset(q, 0, sizeof(PacketQueue));
    pthread_mutex_init(&q->mutex, NULL);
    pthread_cond_init(&q->cond, NULL);
}

void packet_queue_clear(PacketQueue *q){
    MyPacketList *pkt1;
    pthread_mutex_lock(&q->mutex);
    while(q->nb_packets > 0){
        pkt1 = q->first_pkt;
        q->first_pkt = pkt1->next;
        if (!q->first_pkt)
            q->last_pkt = NULL;
        q->nb_packets--;
        free(pkt1);
    }
    pthread_mutex_unlock(&q->mutex);
}

void packet_queue_dispose(PacketQueue *q){
    printf("disposing packet queue...\n");
    MyPacketList *pkt1;
    pthread_mutex_lock(&q->mutex);
    while(q->nb_packets > 0){
        pkt1 = q->first_pkt;
        q->first_pkt = pkt1->next;
        if (!q->first_pkt)
            q->last_pkt = NULL;
        q->nb_packets--;
        free(pkt1);
    }
    q->shouldQuit = 1;
    pthread_cond_broadcast(&q->cond);
    pthread_mutex_unlock(&q->mutex);
    
    pthread_cond_destroy(&q->cond);
    pthread_mutex_destroy(&q->mutex);
    free(q);
}

int packet_queue_put(PacketQueue *q, MyPacket *pkt) {
    MyPacketList *pkt1;
    pkt1 = malloc(sizeof(MyPacketList));
    if (!pkt1)
        return -1;
    pkt1->pkt = *pkt;
    pkt1->next = NULL;
    
    pthread_mutex_lock(&q->mutex);
    if(q->shouldQuit){
        free(pkt1);
        pthread_mutex_unlock(&q->mutex);
        return -1;
    }
    
    if (!q->last_pkt)
        q->first_pkt = pkt1;
    else
        q->last_pkt->next = pkt1;
    q->last_pkt = pkt1;
    q->nb_packets++;
    printf("put packet: %d\n", pkt->value);
    pthread_cond_signal(&q->cond);
    pthread_mutex_unlock(&q->mutex);
    return 0;
}

int packet_queue_get(PacketQueue *q, MyPacket *pkt, int block) {
    
    MyPacketList *pkt1;
    int ret;
    
    pthread_mutex_lock(&q->mutex);
    
    for(;;) {
        if(q->shouldQuit) {
            ret = -1;
            break;
        }
        pkt1 = q->first_pkt;
        if (pkt1) {
            q->first_pkt = pkt1->next;
            if (!q->first_pkt)
                q->last_pkt = NULL;
            q->nb_packets--;
            *pkt = pkt1->pkt;
            free(pkt1);
            ret = 1;
            break;
        } else if (!block) {
            ret = 0;
            break;
        } else {
            printf("pull packet waiting cond...\n");
            pthread_cond_wait(&q->cond, &q->mutex);
            printf("pull packet waiting go!\n");
        }
    }
    
    pthread_mutex_unlock(&q->mutex);
    return ret;
}

void* pull(void *data){
    PacketQueue *queue = data;
    if(queue == NULL){
        printf("queue is NULL");
        return NULL;
    }
    MyPacket pkt;
    int ret = packet_queue_get(queue, &pkt, 1);
    if(ret > 0){
        printf("pull got packet: %d\n", pkt.value);
    }
    else if(ret < 0){
        printf("pull should quit\n");
    }
    else{
        printf("pull got nothing\n");
    }
    return NULL;
}

@interface CThreadController (){
    PacketQueue *queue;
    int i;
    pthread_t pull_thread;
}
@end

@implementation CThreadController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"C Thread";
    [self createBtn:@"put" y:30 selector:@selector(put)];
    [self createBtn:@"signal" y:90 selector:@selector(signal)];
    [self createBtn:@"pull" y:150 selector:@selector(pull)];
    queue = malloc(sizeof(PacketQueue));
    packet_queue_init(queue);
}

-(void)dealloc{
    packet_queue_dispose(queue);
}

-(void)put{
    MyPacket *pk = malloc(sizeof(MyPacket));
    pk->value = ++i;
    packet_queue_put(queue, pk);
}

-(void)signal{
    pthread_cond_signal(&queue->cond);
}

-(void)pull{
    pthread_create(&pull_thread, NULL, pull, queue);
}

-(void)createBtn:(NSString*)title y:(CGFloat)y selector:(SEL)selector{
    UIButton *btn = [xViewFactory buttonWithTitle:title font:kFontPF(14) titleColor:kColor(0xFF6600) bgColor:kColor(0xFFFFFF) cornerRadius:0 borderColor:kColor(0xFF6600) borderWidth:0.5 frame:CGRectMake(0.5*(kContentWidth - 120), y, 120, 40)];
    [btn addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

@end
