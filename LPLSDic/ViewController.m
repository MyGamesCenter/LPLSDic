//
//  ViewController.m
//  LPLSDic
//
//  Created by mickey on 16/7/18.
//  Copyright © 2016年 李盼. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

//#import "PopupView.h"

//语音
#import "iflyMSC/IFlyMSC.h"
#import "IATConfig.h"
#import "iflyMSC/IFlySpeechConstant.h"
#import "iflyMSC/IFlySpeechSynthesizer.h"
#import "iflyMSC/IFlySpeechSynthesizerDelegate.h"


#import "ViewController.h"


#import "UIView+Toast.h"

#import "AFHTTPSessionManager.h"
#import "AFNetworking.h"
#import <AVFoundation/AVFoundation.h>
#import "UIControl+BlocksKit.h"
@interface ViewController ()<IFlySpeechRecognizerDelegate,IFlyRecognizerViewDelegate,IFlySpeechSynthesizerDelegate,AVAudioPlayerDelegate>{
  // 数据列表
  NSMutableArray          *_dataList;
  NSMutableDictionary        *_datadic;
  // XML 元素字符串
  NSMutableString         *_elementString;
  // XML 元素字符串
  NSMutableString         *_textString;
  NSMutableString         *_explainsStr;

  //不带界面的识别对象
  IFlySpeechRecognizer *_iFlySpeechRecognizer;
  IFlyRecognizerView *  _iflyRecognizerView;
  //语音合成
  IFlySpeechSynthesizer * _iFlySpeechSynthesizer;
  //音频
  AVAudioPlayer *_player;
  NSMutableArray * _dataArr;
  NSData * _myData;


}
@property (nonatomic, assign) BOOL isCanceled;
@property (nonatomic, assign) BOOL isSearched;

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view, typically from a nib.
 self.navigationController.navigationBar.translucent = NO;
    [self.activityview setHidesWhenStopped:YES];
  [self.activityview stopAnimating];
  _textString =[NSMutableString string];
  _datadic =[NSMutableDictionary dictionary];
 self.automaticallyAdjustsScrollViewInsets           = NO;
 UITapGestureRecognizer * tap                        = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGesture)];
 self.WordLabel.userInteractionEnabled               = YES;
  [self.WordLabel addGestureRecognizer:tap];
 _iFlySpeechSynthesizer                              = [IFlySpeechSynthesizer sharedInstance]; _iFlySpeechSynthesizer.delegate =
  self;


}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

#pragma mark 语音播报
- (void)tapGesture{
  //设置在线工作方式
  [_iFlySpeechSynthesizer setParameter:[IFlySpeechConstant TYPE_CLOUD]
                                forKey:[IFlySpeechConstant ENGINE_TYPE]];
  //音量,取值范围 0~100
  [_iFlySpeechSynthesizer setParameter:@"50" forKey: [IFlySpeechConstant VOLUME]]; //发音人,默认为”xiaoyan”,可以设置的参数列表可参考“合成发音人列表”
  [_iFlySpeechSynthesizer setParameter:@" xiaoyan " forKey: [IFlySpeechConstant VOICE_NAME]]; //保存合成文件名,如不再需要,设置设置为nil或者为空表示取消,默认目录位于 library/cache下
  [_iFlySpeechSynthesizer setParameter:@" tts.pcm" forKey: [IFlySpeechConstant TTS_AUDIO_PATH]];
  //3.启动合成会话
  [_iFlySpeechSynthesizer startSpeaking:self.WordLabel.text];


}
//4.IFlySpeechSynthesizerDelegate 实现代理
//结束代理
- (void) onCompleted:(IFlySpeechError *) error{
}
//合成开始
- (void) onSpeakBegin{
}
//合成缓冲进度
- (void) onBufferProgress:(int) progress message:(NSString *)msg{
} //合成播放进度
- (void) onSpeakProgress:(int) progress{
}


- (IBAction)wordClick:(UIButton *)sender {
  if (self.word.text.length==0) {
    [self.view makeToast:self.word.placeholder
                duration:1.0
                position:@"center"];
    return;
  }
 self.word.text                                      = [self.word.text lowercaseString];
  [self cancelButton:nil];
  // https://brisk.eu.org/api/xhzd.php
  [_textString setString:@""];
  [_dataList removeAllObjects];
  [_dataArr removeAllObjects];
 self.AMgrammarLabel.text                            = @"";
  self.EnGrammarLabel.text  =@"";
 self.pinyinLabel.text                               = @"";

 self.isSearched                                     = YES;
  //NSLog(@"点击了查找按钮");
  [self.activityview startAnimating];
  [self.word.text stringByReplacingOccurrencesOfString:@" " withString:@""];
  if ([self EngalishwithStr:self.word.text]) {
    [self getDictionary:[NSString stringWithFormat:@"http://dict-co.iciba.com/api/dictionary.php?w=%@&key=E25FD7AAD5B9B9922A6326F0F63682D4",self.word.text ] word:self.word.text];


  }else{
    [self requestWithUrl:[NSString stringWithFormat:@"http://fanyi.youdao.com/openapi.do?keyfrom=rmbbox&key=927563036&type=data&doctype=json&version=1.1&q=%@",self.word.text ]];

  }

  [self.view endEditing:YES];

}

#pragma mark 网络请求
-(void)requestWithUrl:(NSString*)url{
 NSString *encoded                                   = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//  NSURL * urls =[NSURL URLWithString:encoded];
  [self.activityview setHidden:NO];
  [self.activityview startAnimating];


 AFHTTPRequestOperationManager *manager              = [AFHTTPRequestOperationManager manager];
         manager.responseSerializer.acceptableContentTypes =[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"xml/json",@"text/xml", nil];
//  manager.responseSerializer = [AFXMLParserResponseSerializer serializer];
  [manager GET:encoded parameters:nil success:^(AFHTTPRequestOperation *operation, id json) {

 NSData *data                                        = [NSJSONSerialization dataWithJSONObject:json options:0 error:NULL];


 NSDictionary *dict                                  = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];



                NSLog(@"%@",dict);
    [self jsonWithDic:dict];
    [self.activityview stopAnimating];
    [self.activityview setHidden:YES];

    //             self.textView.text = stringM;
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    NSLog(@"error:%@",error);
    [self.activityview stopAnimating];
    [self.activityview setHidden:YES];

 self.textView.text                                  = [NSString stringWithFormat:@"%@",error];
  }];



}
#pragma mark xml 请求
- (void)getDictionary :(NSString *)strUrl word:(NSString *)word{



 NSURL  * url                                        = [NSURL URLWithString:strUrl];
  NSData * data  =[[NSData alloc]initWithContentsOfURL:url];
  NSString * resultStr  =[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
  NSLog(@"%@",resultStr);
 NSXMLParser * paser                                 = [[NSXMLParser alloc]initWithData:data];
  [paser setDelegate:self];
  [paser parse];
}

#pragma mark json 解析
-(void)jsonWithDic:(NSDictionary*)dic{
  _explainsStr  =[NSMutableString string];
  [_explainsStr setString:@""];
  self.WordLabel.text =[dic valueForKey:@"query"];
  self.EnchnagechinesetextField.text =[[dic valueForKey:@"translation"] firstObject];
  [_explainsStr setString:@""];
  for (NSString * key in dic.allKeys) {
    if ([key isEqualToString:@"basic"]) {
      self.pinyinLabel.text =[[dic valueForKey:@"basic"] valueForKey:@"phonetic" ];
      for (NSString * str  in [[dic valueForKey:@"basic"] valueForKey:@"explains" ]) {
        [_explainsStr appendString:[NSString stringWithFormat:@"%@,",str]];

      }
 self.EnchnagechinesetextField.text                  = _explainsStr;
      break;
    }
  }


  for (NSDictionary * dict in [dic valueForKey:@"web"]) {
    [_textString appendString:[NSString stringWithFormat:@"词语:%@\n翻译：",[dict valueForKey:@"key"]]];
    for (NSString*  str in [dict valueForKey:@"value"]) {
      [_textString appendString:[NSString stringWithFormat:@":%@，",str]];
    }
    [_textString appendString:@"\n"];

  }
 self.textView.text                                  = _textString;

}

#pragma mark - XMl 数据解析
#pragma mark NSXMLParserDelegate 委托方法
// 4. 开始解析XML文档
- (void)parserDidStartDocument:(NSXMLParser *)parser
{
  NSLog(@"开始解析XML文档");

  // 初始化数据数组
  if (_dataList == nil) {
 _dataList                                           = [NSMutableArray array];
    //    _dataListArr =[NSMutableArray array];
  } else {
    [_dataList removeAllObjects];
  }

  // 初始化元素字符串
  if (_elementString == nil) {
 _elementString                                      = [NSMutableString string];
  } else {
    [_elementString setString:@""];
  }
}

// 1. 开始解析某个元素，会遍历整个XML，识别元素节点名称
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
  NSLog(@"开始解析某个元素 %@", elementName);
  // 判断元素节点是否为"video"
  if ([elementName isEqualToString:@"dict"]) {

    // 如果已经开始解析，此方法调用时，是开始新的解析，因此需要将此前的视频元素添加到数组
    //    if (_currentVideo) {
    //      [_dataList addObject:_currentVideo];
    //    }

    // 新建视频元素
    //    _currentVideo = [[Video alloc]init];

    // 判断是否存在属性id节点
    if (attributeDict[@"id"]) {
      // 设置视频对象的id属性
      //      [_currentVideo setId:[attributeDict[@"id"]integerValue]];
      NSLog(@"%ld",[attributeDict[@"id"]integerValue]);
    }
  }
  // 注意：确保解析文本节点之前，元素字符串内容为空
  [_elementString setString:@""];
}

// 2. 文本节点，得到文本节点里存储的信息数据，对于大数据可能会接收多次！
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
  // 追加文本节点内容
  // 注意在前面方法已经将_elementString赋为空字符串
  // 从而能够保证大数据的追加
  [_elementString appendString:string];
}

// 3. 结束某个节点，存储从parser:foundCharacters:方法中获取到的信息
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
//  NSString *str = [NSString stringWithString:_elementString];

  //  [_dataList setObject:_elementString forKey:elementName];
  //  _dataList  =[[NSMutableDictionary alloc]initWithDictionary:@{elementName:_elementString}];

  [_dataList addObject:@{elementName :[NSString stringWithFormat:@"%@",_elementString]}];

  //   根据elementName，用解析的节点内容设置当前视频对象属性
  if ([elementName isEqualToString:@"key"]) {

 self.WordLabel.text                                 = _elementString;
  } else if ([elementName isEqualToString:@"ps"]) {
    if (self.isSearched) {
 self.AMgrammarLabel.text                            = @"";
      self.isSearched =!self.isSearched;
    }
    if ([self.AMgrammarLabel.text isEqualToString:@""]) {
 self.AMgrammarLabel.text                            = _elementString;
    }else{
 self.EnGrammarLabel.text                            = _elementString;
    }

  } else if ([elementName isEqualToString:@"pron"]) {
    //    [_currentVideo setVideoURL:[NSString stringWithFormat:@"%@%@", WEB_ROOT_URL, str]];

    if (_player.playing) {
      return;
    }
    [self playwithDate:[[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:_elementString] ]];

  } else if ([elementName isEqualToString:@"acceptation"]) {
 self.EnchnagechinesetextField.text                  = _elementString;
  } else if ([elementName isEqualToString:@"orig"]) {

    [_textString appendString:[NSString stringWithFormat:@"\n句子:"]];
    [_textString appendString:_elementString];
  } else if ([elementName isEqualToString:@"trans"]) {
    [_textString appendString:[NSString stringWithFormat:@"\n翻译:"]];
    [_textString appendString:_elementString];
  }
}

// 5. 解析XML文档结束
- (void)parserDidEndDocument:(NSXMLParser *)parser
{
  NSLog(@"解析XMl文档结束");

  // 将最后一个视频对象添加至数据列表
  // 注意如果不释放当前视频对象，重新刷新会出错！
  //  [_dataList addObject:_currentVideo];

  // 释放当前视频对象
  //  _currentVideo = nil;

  // 刷新表格
  //  [_videosTable reloadData];

  _dataArr =[NSMutableArray array];
  for (NSDictionary * dic in _dataList) {
    if ([[dic allKeys].firstObject isEqualToString:@"pron"]) {
      [_dataArr addObject:[dic valueForKey:[dic allKeys].firstObject]];

        }else {
      continue;
    }

  }



  [self.AMbutton bk_addEventHandler:^(id sender) {
//    _myData=[[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:_dataArr[0]]];
    _dataArr.count<1?@"":  [self playwithDate:[[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:_dataArr[0]]]];

  } forControlEvents:UIControlEventTouchUpInside];

  [self.ENButton bk_addEventHandler:^(id sender) {
//      _myData=[[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:_dataArr[1]]];
   _dataArr.count<2?@"":   [self playwithDate:[[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:_dataArr[1]]]];

  } forControlEvents:UIControlEventTouchUpInside];

 self.textView.text                                  = _textString;
   [self.activityview stopAnimating];

}


// 6. 解析出错
- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
  NSLog(@"解析XML文档出错：%@", parseError.localizedDescription);
}




#pragma mark 语音合成
- (IBAction)star:(id)sender {
  NSLog(@"%s[IN]",__func__);

       [self initRecognizer ];
    //设置音频来源为麦克风
    [_iflyRecognizerView setParameter:IFLY_AUDIO_SOURCE_MIC forKey:@"audio_source"];

    //设置听写结果格式为json
    [_iflyRecognizerView setParameter:@"plain" forKey:[IFlySpeechConstant RESULT_TYPE]];

    //保存录音文件，保存在sdk工作路径中，如未设置工作路径，则默认保存在library/cache下
    [_iflyRecognizerView setParameter:@"asr.pcm" forKey:[IFlySpeechConstant ASR_AUDIO_PATH]];

    [_iflyRecognizerView start];



}



-(void)initRecognizer
{
       //UI显示剧中
 _iflyRecognizerView                                 = [[IFlyRecognizerView alloc] initWithCenter:self.view.center];

      [_iflyRecognizerView setParameter:@"" forKey:[IFlySpeechConstant PARAMS]];

      //设置听写模式
      [_iflyRecognizerView setParameter:@"iat" forKey:[IFlySpeechConstant IFLY_DOMAIN]];


 _iflyRecognizerView.delegate                        = self;

 IATConfig *instance                                 = [IATConfig sharedInstance];

      //设置最长录音时间
      [_iflyRecognizerView setParameter:instance.speechTimeout forKey:[IFlySpeechConstant SPEECH_TIMEOUT]];
      //设置后端点
      [_iflyRecognizerView setParameter:instance.vadEos forKey:[IFlySpeechConstant VAD_EOS]];
      //设置前端点
      [_iflyRecognizerView setParameter:instance.vadBos forKey:[IFlySpeechConstant VAD_BOS]];
      //网络等待时间
      [_iflyRecognizerView setParameter:@"20000" forKey:[IFlySpeechConstant NET_TIMEOUT]];

      //设置采样率，推荐使用16K
      [_iflyRecognizerView setParameter:instance.sampleRate forKey:[IFlySpeechConstant SAMPLE_RATE]];
      if ([instance.language isEqualToString:[IATConfig chinese]]) {
        //设置语言
        [_iflyRecognizerView setParameter:instance.language forKey:[IFlySpeechConstant LANGUAGE]];
        //设置方言
        [_iflyRecognizerView setParameter:instance.accent forKey:[IFlySpeechConstant ACCENT]];
      }else if ([instance.language isEqualToString:[IATConfig english]]) {
        //设置语言
        [_iflyRecognizerView setParameter:instance.language forKey:[IFlySpeechConstant LANGUAGE]];
      }
      //设置是否返回标点符号
      [_iflyRecognizerView setParameter:instance.dot forKey:[IFlySpeechConstant ASR_PTT]];




}
//4. IFlySpeechRecognizerDelegate识别代理
/*识别结果返回代理
 @param :results识别结果
 @ param :isLast 表示是否最后一次结果
 */
- (void) onResults:(NSArray *) results isLast:(BOOL)isLast{

}
/*识别会话结束返回代理
 @ param error 错误码,error.errorCode                   = 0表示正常结束,非0表示发生错误。 */
- (void)onError: (IFlySpeechError *) error{

}

- (void)onResult:(NSArray *)resultArray isLast:(BOOL) isLast{
  if ([[resultArray.firstObject allKeys].firstObject isEqualToString:@"."]) {
    return;
  }
 self.word.text                                      = [[resultArray.firstObject allKeys].firstObject lowercaseString];
   [self.word.text stringByReplacingOccurrencesOfString:@"." withString:@""];

  [self wordClick:nil];
}

/**
 停止录音回调
 ****/
- (void) onEndOfSpeech {

}
/**
 开始识别回调
 ****/
- (void) onBeginOfSpeech {

}
/**
 音量回调函数 volume 0-30****/
- (void) onVolumeChanged: (int)volume {

}

#pragma mark 取消第一响应
- (IBAction)cancelButton:(id)sender {
  [self.EnchnagechinesetextField resignFirstResponder];
  [self.textView resignFirstResponder];
  [self.word resignFirstResponder];

}



#pragma mark 播放语音
-(void)playwithDate:(NSData*)data{
  NSError*err;
  if (_player.playing) {
    [_player stop];
  }

  if (_player!=nil) {
 _player                                             = nil ;
  }
  _player=[[AVAudioPlayer alloc]initWithData:data error:&err];
  //            NSLog(@"%@",_myData);

  //            NSError *error = nil;
  //            _player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL URLWithString:urlStr] error:&error];
 _player.delegate                                    = self;

  if (err != nil) {
 NSLog(@"error                                       = %@",err);
  } else {


    [_player prepareToPlay];
    [_player play];

  }

  NSLog(@"%@",err);
  if(_player.playing==YES){
    NSLog(@"Playing");


  }
}




- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
  NSLog(@"%s,%d",__FUNCTION__,__LINE__);

}

- (void)audioPlayerBeginInterruption:(AVAudioPlayer *)player
{
  NSLog(@"%s,%d",__FUNCTION__,__LINE__);
}
- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error
{
 NSLog(@"error                                       = %@",error);
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}



#pragma mark 检验是否是英文还是汉字
-(BOOL)EngalishwithStr:(NSString*)str{
  if(str){
 for (int i                                          = 0; i<str.length; i++) {
 NSRange range                                       = NSMakeRange(i,1);
      NSString *subString=[str substringWithRange:range];
      const char *cString=[subString UTF8String];
      if (strlen(cString)==3)
      {
        NSLog(@"昵称是汉字");
                  return NO;
        }
      else if(strlen(cString)==1)
      {
        NSLog(@"昵称是字母");
 NSRange _range                                      = [str rangeOfString:@" "];
        if (_range.location != NSNotFound) {
          //有空格
            return NO;

        }else {
            return YES;
          //没有空格
        }




      }

    }

  }
  return nil;
}

@end
