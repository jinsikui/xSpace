

#import "EventController.h"
#import "xNotice.h"

#define NotiName @"MyNoti"

@interface EventController ()<UIScrollViewDelegate>{
    UITextView *textView_;
}
@property(nonatomic,strong) xTimer *timer;

@end

@implementation EventController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"事件处理";
    self.view.backgroundColor = [UIColor whiteColor];
    //
    UIScrollView *scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kContentWidth, kContentHeight)];
    scroll.delegate = self;
    scroll.contentSize = CGSizeMake(0, kContentHeight + 1);
    [self.view addSubview:scroll];
    //
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeSystem];
    btn1.frame = CGRectMake(0.5*(kContentWidth - 100), 50, 100, 50);
    [btn1 setTitle:@"按钮1" forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(btn1Click:) forControlEvents:UIControlEventTouchUpInside];
    [scroll addSubview:btn1];
    //
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0.5*(kContentWidth - 100), 110, 100, 50)];
    label1.textAlignment = NSTextAlignmentCenter;
    label1.text = @"标签1";
    UITapGestureRecognizer *g = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(label1Click:)];
    [label1 addGestureRecognizer:g];
    label1.userInteractionEnabled = YES;
    [scroll addSubview:label1];
    //
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeSystem];
    btn2.frame = CGRectMake(0.5*(kContentWidth - 100), 170, 100, 50);
    [btn2 setTitle:@"按钮2" forState:UIControlStateNormal];
    [btn2 addTarget:self action:@selector(btn2Click:) forControlEvents:UIControlEventTouchUpInside];
    [scroll addSubview:btn2];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notiHandler:) name:NotiName object:nil];
    //
    UITextView *t = [[UITextView alloc] initWithFrame:CGRectMake(20, 230, kContentWidth - 40, kContentHeight - 230)];
    textView_ = t;
    [scroll addSubview:t];
    
    //
    [[xNotice shared] registerEvent:@"customEvent" lifeIndicator:self action:^(id param) {
        NSLog(@"===== fire custom event, name:%@ =====", ((NSDictionary<NSString*, id>*)param)[@"name"]);
    }];
    
    [[xNotice shared] registerTimer:self intervalSeconds:3 action:^{
        NSLog(@"===== xNotice Timer fire =====");
    }];
    self.timer = [xTimer timerOnGlobalWithIntervalSeconds:2 fireOnStart:YES action:^{
        NSLog(@"===== xTimer fire =====");
    }];
    [self.timer start];
}

-(void)appendStr:(NSString*)str{
    NSString *s = textView_.text;
    if(!s){
        s = str;
    }
    else{
        s = [NSString stringWithFormat:@"%@\n%@", str, s];
    }
    textView_.text = s;
}

-(void)notiHandler:(NSNotification *)sender{
    [self appendStr:@"收到系统通知"];
}

-(void)btn2Click:(UIButton*)btn{
    [self appendStr:@"btn2 click"];
    [[NSNotificationCenter defaultCenter] postNotificationName:NotiName object:nil];
    [[xNotice shared] postEvent:@"customEvent" userInfo:@{@"name": @"hello world"}];
}

-(void)label1Click:(UILabel*)label{
    [self appendStr:@"label1 click"];
}

-(void)btn1Click:(UIButton*)btn{
    [self appendStr:@"btn1 click"];
}

//UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self appendStr:@"scrollViewWillBeginDragging"];
}

//系统

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
