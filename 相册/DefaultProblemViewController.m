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
}
@property(nonatomic,strong)UITableView * defaultTableView;
@property(nonatomic,strong)UIButton * buttonAdd;
@property(nonatomic,strong)UITextField *problemText;

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

    
    
}
-(void)addButtonAction{
    [self creatAlertController_alert];
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

-(void)addDefaultProblemAction:(NSString *)str{
    NSMutableArray * arr  =[NSMutableArray arrayWithContentsOfFile:defaultTmp];
   
    if (arr.count == 0) {
        
        [arr addObject:str];
    }else{

        [arr addObject:str];
        
    }
    for (NSString *str in arr) {
        if (![defaultArray containsObject:str]) {
            [defaultArray addObject:str];
        }
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
//     [array1 replaceObjectAtIndex:2 withObject:@"hhh"];
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
