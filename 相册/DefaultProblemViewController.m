//
//  DefaultProblemViewController.m
//  相册
//
//  Created by 软通 on 2018/6/27.
//  Copyright © 2018年 com.hulin. All rights reserved.
//

#import "DefaultProblemViewController.h"

@interface DefaultProblemViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSString * defaultTmp;
    NSMutableArray *defaultArray;
    NSInteger type;//0：添加 1：修改
    NSInteger arrNum;
}
@property(nonatomic,strong)UITableView * defaultTableView;
@property(nonatomic,strong)UIButton * buttonAdd;
@property(nonatomic,strong)UITextView * problemText;
@property(nonatomic,strong)UIView * alphaView;
@property(nonatomic,strong)UIView * problemView;
@property(nonatomic,strong)UIButton * okTextButton;
@property(nonatomic,strong)UIButton * noTextButton;
@end

@implementation DefaultProblemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //预设语句的沙盒路径
    NSString * tmp =NSTemporaryDirectory();
    defaultTmp = [tmp stringByAppendingString:@"/DefaultProblem.plist"];
    //    defaultArray = [NSMutableArray array];
    defaultArray = [NSMutableArray arrayWithContentsOfFile:defaultTmp];
    
    self.defaultTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 60, self.view.frame.size.width, self.view.frame.size.height - 60) style:(UITableViewStylePlain)];
    [self.view addSubview:self.defaultTableView];
    self.defaultTableView.delegate = self;
    self.defaultTableView.dataSource = self;
    
    self.buttonAdd = [UIButton buttonWithType:(UIButtonTypeCustom)];
    self.buttonAdd.frame =CGRectMake(300, 20, 50, 35);
    [self.buttonAdd setTitle:@"添加" forState:(UIControlStateNormal)];
    [self.buttonAdd setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    [self.view addSubview:self.buttonAdd];
    [self.buttonAdd addTarget:self action:@selector(addButtonAction) forControlEvents:(UIControlEventTouchUpInside)];
    self.alphaView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.alphaView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.alphaView];
    self.alphaView.hidden = YES;
    self.problemView = [[UIView alloc] initWithFrame:CGRectMake(30, 200, 325, 400)];
    self.problemView.hidden = YES;
    //设置圆角边框
    self.problemView.layer.cornerRadius = 8;
    self.problemView.layer.masksToBounds = YES;
    
    //设置边框及边框颜色
    self.problemView.layer.borderWidth = 1;
    self.problemView.layer.borderColor =[ [UIColor grayColor] CGColor];
//    self.problemView.hidden = YES;
    self.problemView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.problemView];
    self.problemText = [[UITextView alloc] initWithFrame:CGRectMake(20, 30, 285, 250)];
    self.problemText.layer.cornerRadius = 8;
    self.problemText.layer.masksToBounds = YES;
    self.problemText.layer.borderWidth = 1;
    self.problemText.layer.borderColor = [UIColor grayColor].CGColor;
    [self.problemView addSubview:self.problemText];
    self.okTextButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    self.okTextButton.frame = CGRectMake(175, 330, 100, 50);
    self.okTextButton.backgroundColor = [UIColor blueColor];
    self.okTextButton.layer.cornerRadius = 10;
    self.okTextButton.layer.masksToBounds = YES;
    [self.okTextButton setTitle:@"确定" forState:(UIControlStateNormal)];
    [self.okTextButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [self.okTextButton addTarget:self action:@selector(okTextButtonAction) forControlEvents:(UIControlEventTouchUpInside)];
    [self.problemView addSubview:self.okTextButton];
    self.noTextButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    self.noTextButton.frame = CGRectMake(50, 330, 100, 50);
    self.noTextButton.backgroundColor = [UIColor blueColor];
    self.noTextButton.layer.cornerRadius = 10;
    self.noTextButton.layer.masksToBounds = YES;
    [self.noTextButton setTitle:@"取消" forState:(UIControlStateNormal)];
    [self.noTextButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [self.noTextButton addTarget:self action:@selector(noTextButtonAction) forControlEvents:(UIControlEventTouchUpInside)];
    [self.problemView addSubview:self.noTextButton];
}
-(void)addButtonAction{
    type = 0;
    self.alphaView.hidden = NO;
    self.problemView.hidden = NO;
}
-(void)okTextButtonAction{
    
    if (type == 0) {
        //添加
        [self addDefaultProblemAction:self.problemText.text];
    }else{
        //修改
        [self xiugaiDefaultProblemAction:self.problemText.text];
    }
    self.problemText.text = nil;
    self.alphaView.hidden = YES;
    self.problemView.hidden = YES;
}
-(void)noTextButtonAction{
    self.problemText.text = nil;
    self.alphaView.hidden = YES;
    self.problemView.hidden = YES;
}
-(void)creatAlertController_alert {
    //跟上面的流程差不多，记得要把preferredStyle换成UIAlertControllerStyleAlert
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"标题" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    //可以给alertview中添加一个输入框
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输入";
    }];
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //textFields是一个数组，获取所输入的字符串
        NSLog(@"%@",alert.textFields.lastObject.text);
        [self addDefaultProblemAction:alert.textFields.lastObject.text];
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"点击了取消");
    }];
    
    [alert addAction:action1];
    [alert addAction:action2];
    
    [self presentViewController:alert animated:YES completion:nil];
}
-(void)xiugaiDefaultProblemAction:(NSString *)str{
    NSMutableArray * arr  =[NSMutableArray arrayWithContentsOfFile:defaultTmp];
    BOOL isbool = [arr containsObject: str];
    if (isbool == NO) {
         NSLog(@"修改成功");
        [defaultArray replaceObjectAtIndex:arrNum withObject:str];
        [defaultArray writeToFile:defaultTmp atomically:YES];
        [self.defaultTableView reloadData];
    }else{
        NSLog(@"已存在");
    }


}

-(void)addDefaultProblemAction:(NSString *)str{
    NSMutableArray * arr  =[NSMutableArray arrayWithContentsOfFile:defaultTmp];
        [arr addObject:str];
    for (NSString *str in arr) {
        if (![defaultArray containsObject:str]) {
            [defaultArray addObject:str];
            NSLog(@"str = %@",str);
        }
    }
    NSLog(@"arr =%@ defaultArray = %@",arr,defaultArray);
    if (arr.count != defaultArray.count) {
        NSLog(@"语句已存在");
    }else{
        NSLog(@"语句已成功保存");
    }
    
    [defaultArray writeToFile:defaultTmp atomically:YES];
    
    [self.defaultTableView reloadData];
    
}

#pragma mark - 显示的行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return defaultArray.count;
}
#pragma mark - 每一行信息的内容
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cell_id = @"cell_id";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cell_id];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleSubtitle) reuseIdentifier:cell_id];
    }
    cell.textLabel.text = defaultArray[indexPath.row];
    return cell;
}
#pragma mark - 组数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
//cell点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    type = 1;
    arrNum = indexPath.row;
    self.alphaView.hidden = NO;
    self.problemView.hidden = NO;
    //     [array1 replaceObjectAtIndex:2 withObject:@"hhh"];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
