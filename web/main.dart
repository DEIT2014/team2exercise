// Copyright (c) 2016, <your name>. All rights reserved. Use of this source code

// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:html';
import 'dart:core';
import 'dart:async';
import 'package:route_hierarchical/client.dart';
import 'dart:convert' show JSON;

var localhost = "127.0.0.1:14080";
InputElement signin_username; //登录界面的用户名变量

InputElement signin_password; //登录界面的密码变量

InputElement signup_username; //注册界面的用户名变量

InputElement signup_class; //注册界面的班级变量

InputElement signup_password; //注册界面的密码变量

InputElement signup_confirmpw; //注册界面确认密码的变量

var test_word; //学生听写写入的单词

//var PassWord;
//var ConPassWord;

void main() {
  /// 登录界面
  document
      .querySelector('#SignIn_Div_Form')
      .style
      .display = "block";
  signin_username = querySelector('#SignIn_Username'); //输入用户名
  signin_password = querySelector('#SignIn_Password'); //输入密码
  var router = new Router(useFragment: true);
  router.root..addRoute(
      name: 'signup', path: '/signup', enter: SignUp)..addRoute(
      name: 'home', path: '/', enter: (_) => null);
  querySelector('#SignUp_Btn').attributes['href'] = router.url('signup');
  router.listen();
  querySelector("#SignIn_Btn").onClick.listen(SignIn);

  /// 注册界面
  signup_username = querySelector('#SignUp_Username'); //输入用户名
  signup_class = querySelector('#SignUp_Class'); //输入班级
  signup_password = querySelector('#SignUp_Password'); //输入密码
  signup_confirmpw = querySelector('#SignUp_ConfirmPW'); //确认密码

  var SignUp_Stu_Btn = querySelector('#SignUp_Stu_Btn'); //学生注册按钮
  SignUp_Stu_Btn.onClick.listen(StuSignUp);
  querySelector('#SignUp_Tea_Btn').onClick.listen(TeaSignUp); //教师注册按钮

  /// 注册成功界面
  querySelector('#SucSignUp_Btn')
    ..text = '确定'
    ..onClick.listen(ReturnSignIn); //返回登录界面按钮

  /// 教师主界面
  /// 待定

  /// 任务完成情况界面
  querySelector('#Ftask_Content')
    ..text = FtaskContent(); // 任务完成情况
  querySelector('#Ftask_Btn')
    ..text = '返回主界面'
    ..onClick.listen(ReturnTeacher); //返回教师主界面按钮

  /// 布置任务界面
  querySelector('#AssignWork_Btn')
    ..text = '提交'
    ..onClick.listen(SubmitWork); // 提交作业按钮

  ///确认单词界面
  querySelector('#ConfirmWord_Show')
    ..text = WordContent(); //选择的单词内容
  querySelector('#ConfirmWord_Confirm_Btn')
    ..text = '确认'
    ..onClick.listen(ConfirmWord); //确认单词以及发布作业的按钮
  querySelector('#ConfirmWord_Reselect_Btn')
    ..text = '重新选择'
    ..onClick.listen(ReselectWord); //重新选择单词按钮

  ///布置作业成功界面
  querySelector('#SucAssignWord_Btn')
    ..text = '返回主界面'
    ..onClick.listen(ReturnTeacher); //返回教师主界面的按钮

  /// 学生界面
  querySelector('#stu_name')
    ..text = stu_name_show(); //学生姓名的数据
  querySelector('#stu_class')
    ..text = stu_class_show(); //学生班级的数据
  querySelector('#stu_task_one')
    ..text = stu_task_one_show()
    ..onClick.listen(stu_task_one); //待完成任务1名称的数据以及记录是否选择此任务
  querySelector('#stu_task_two')
    ..text = stu_task_two_show()
    ..onClick.listen(stu_task_two); //待完成任务2名称的数据以及记录是否选择此任务
  querySelector('#stu_review')
    ..text = '复习单词'
    ..onClick.listen(stu_review_word);
  querySelector('#stu_test')
    ..text = '开始测试'
    ..onClick.listen(stu_test_word);
  //查看已完成任务界面
  querySelector('#finished_task_one')
    ..text = finished_task_one()
    ..onClick.listen(finished_task_one_show);
  querySelector('#finished_task_two')
    ..text = finished_task_two()
    ..onClick.listen(finished_task_two_show);
  querySelector('#finished_task_three')
    ..text = finished_task_three()
    ..onClick.listen(finished_task_three_show);
  querySelector('#finished_return')
    ..text = '返回主页'
    ..onClick.listen(finished_return);

  ///复习界面
  querySelector('#review_now_num')
    ..text = review_now_num_show(); //显示当前复习的单词为第几个的数据
  querySelector('#review_total_num')
    ..text = review_total_num_show(); //当前复习总共有几个单词
  querySelector('#review_word')
    ..text = review_word_show(); //当前复习单词的中文或者英文
  querySelector('#review_voice')
    ..onClick.listen(review_voice);
  querySelector('#review_change')
    ..text = '中英文切换'
    ..onClick.listen(review_change);
  querySelector('#review_next')
    ..text = '下一个'
    ..onClick.listen(review_next);
  querySelector('#review_again')
    ..text = '重新复习'
    ..onClick.listen(review_again);
  querySelector('#review_test')
    ..text = '开始测试'
    ..onClick.listen(review_test);

  ///测试界面
  querySelector('#test_now_num')
    ..text = test_now_num_show(); //显示当前测试的单词为第几个的数据
  querySelector('#test_total_num')
    ..text = test_total_num_show(); //向服务器请求读取数据库中当前测试总共有几个单词
  test_word = querySelector('#test_total_num').text;
  querySelector('#test_option_one')
    ..text = test_option_one_show(); //向服务器请求读取数据库中随机的单词中文或者正确的单词中文
  querySelector('#test_option_two')
    ..text = test_option_two_show(); //向服务器请求读取数据库中随机的单词中文或者正确的单词中文
  querySelector('#test_option_three')
    ..text = test_option_three_show(); //向服务器请求读取数据库中随机的单词中文或者正确的单词中文
  querySelector('#test_submit')
    ..text = '提交'
    ..onClick.listen(test_submit);

  ///结果界面
  querySelector('#result_correct_num')
    ..text = result_correct_num_show(); //向服务器请求读取数据库中正确单词个数
  querySelector('#result_wrong_one')
    ..text = result_wrong_one_show(); //向服务器请求读取数据库中第一个错误单词的中英文
  querySelector('#result_wrong_two')
    ..text = result_wrong_two_show(); //向服务器请求读取数据库中第二个错误单词的中英文
  querySelector('#result_return')
    ..text = '返回主页'
    ..onClick.listen(result_return);
}


void SignUp(RouteEvent e) {
  document
      .querySelector('#SignUp_Div_Form')
      .style
      .display = "block";
  document
      .querySelector('#SignIn_Div_Form')
      .style
      .display = "none";
}

/// 用来接受用户点击登录按钮以后的响应工作
void SignIn(MouseEvent event) {
  //todo 记录输入的用户名和密码并与数据库进行比较，
  //todo 若对比成功，隐藏登录界面，显示教师或者学生界面（根据相应的标志值判断）
  var request = HttpRequest.getString("http://127.0.0.1:14080/userinfo").then(
      onSignIn);
}

void onSignIn(responseText) {
  //var jsonString ='{"Userinfo":[{"Username": "wang", "Password": "3882", "Class": "class9", "Status": "stu"},{"Username": "jiang", "Password": "6712", "Class": "class6", "Status": "tea"}]}';
  //var userinfo=JSON.decode(MapAsJson);
//  var userinfolist=userinfo["Userinfo"];
  var jsonString = responseText;
  var userinfo = JSON.decode(jsonString);
  var userinfolist = userinfo["Userinfo"];
  int a = 0;
  print(signin_username.value);
  for (var x in userinfolist) {
    print(x["Username"]);
    if (x["Username"] == signin_username.value) {
      print(x["Password"]);
      if (x["Password"] == signin_password.value) {
        print(x["Status"]);
        if (x["Status"] == "stu") {
          //隐藏登录转到学生界面
          var router1 = new Router(useFragment: true);
          router1.root
            ..addRoute(
                name: 'stu_signin', path: '/stu/index', enter: StuSignIn);
          querySelector('#SignIn_Btn').attributes['href'] =
              router1.url('stu_signin');
          router1.listen();
          a = 1;
        }
        else {
          //隐藏登录转到教师界面
          var router2 = new Router(useFragment: true);
          router2.root
            ..addRoute(
                name: 'tea_signin', path: '/tea/index', enter: TeaSignIn);
          querySelector('#SignIn_Btn').attributes['href'] =
              router2.url('tea_signin');
          router2.listen();
          a = 1;
        }
      }
    }
  }
  if (a == 0) {
    querySelector("#SignIn_Error").text = "用户名或者密码错误，请重新登录";
  }
}

void StuSignIn(RouteEvent e) {
  document
      .querySelector('#student')
      .style
      .display = "block";
  document
      .querySelector('#SignIn_Div_Form')
      .style
      .display = "none";
}

void TeaSignIn(RouteEvent e) {
  document
      .querySelector('#Teacher_Div')
      .style
      .display = "block";
  document
      .querySelector('#SignIn_Div_Form')
      .style
      .display = "none";
}

/// 接受用户点击学生注册按钮的响应
/// 参数[event]是鼠标事件....
void StuSignUp(MouseEvent event) {
  //todo 将数据写入数据库中的用户信息表，并将身份属性值设为stu
  //todo 显示注册成功界面
  var SignUpUserName= signup_username.value;
  var SignUpClass=signup_class.value;
  var SignUpPassword=signup_password.value;
  var SignUpConPassword=signup_confirmpw.value;
  //if判断语句：用户名和密码是否为空，空时给出提示
  if(SignUpUserName==''||  SignUpPassword=='' || SignUpConPassword=='')
  {
    querySelector("#signuperror").text="用户名和密码不能为空！";
  }
  //else:对数据进行处理
  else{
    //if判断语句：密码和确认密码是否一致，不一致时给出提示（else语句在下面）
    if (signup_password.value == signup_confirmpw.value) {
      Map data = {
        "Username":'${SignUpUserName}',
        "Class":'${SignUpClass}',
        "Password":'${SignUpPassword}'
      };
      var jsonData = JSON.encode(data);
      //创建post的request
      HttpRequest request = new HttpRequest(); //create a new XHR=XMLHttpRequest
      //创建一个事件处理器，等到request被处理好之后，返回response时调用
      request.onReadyStateChange.listen((_) {
        //if条件：状态改变
        if (request.readyState == HttpRequest.DONE &&
            (request.status == 200 || request.status == 0)) {
          //if判断语句：注册是否成功，成功跳转到另一个url处，否则给出错误提示：该用户已经注册......
          if(request.responseText == 'success'){
            var router2 = new Router(useFragment: true);
            router2.root
              ..addRoute(
                  name: 'SStuSignUp', path: '/stu/signup/succeed', enter: SSignUp);
            querySelector('#SignUp_Stu_Btn').attributes['href'] =
                router2.url('SStuSignUp');
            router2.listen();
          }
          else{
            querySelector("#signuperror").text="该用户已注册，请更换用户名或班级";
          }
          //end 注册是否成功的if
        }
      });
      //post data to the server
      var url = "http://127.0.0.1:14080/student_signup";
      request.open("POST", url, async: false);
      request.send(jsonData); //perform the post

    }
    //else：两次密码不同，给出提示
    else{
      querySelector("#signuperror").text = "两次输入密码不同，请重新输入！";
    }
    //end 两次密码是否一致的if
  }
  //end 用户名和密码是否为空的if
}

void SSignUp(RouteEvent e) {
  document
      .querySelector('#Background_Soe')
      .style
      .display = "block";
  document
      .querySelector('#SignUp_Div_Form')
      .style
      .display = "none";
}


/// 接受用户点击教师注册按钮的响应
/// 参数[event]是鼠标事件....
///此处为参考代码
void TeaSignUp(MouseEvent event) {
  //todo 将数据写入数据库中的用户信息表，并将身份属性值设为tea
  //todo 显示注册成功界面
  var SignUpUserName= signup_username.value;
  var SignUpClass=signup_class.value;
  var SignUpPassword=signup_password.value;
  var SignUpConPassword=signup_confirmpw.value;
  //if判断语句：用户名和密码是否为空，空时给出提示
  if(SignUpUserName==''||  SignUpPassword=='' || SignUpConPassword=='')
  {
    querySelector("#signuperror").text="用户名和密码不能为空！";
  }
  //else:对数据进行处理
  else{
    //if判断语句：密码和确认密码是否一致，不一致时给出提示（else语句在下面）
    if (signup_password.value == signup_confirmpw.value) {
      Map data = {
        "Username":'${SignUpUserName}',
        "Class":'${SignUpClass}',
        "Password":'${SignUpPassword}'
      };
      var jsonData = JSON.encode(data);
      //创建post的request
      HttpRequest request = new HttpRequest(); //create a new XHR=XMLHttpRequest
      //创建一个事件处理器，等到request被处理好之后，返回response时调用
      request.onReadyStateChange.listen((_) {
        //if条件：状态改变
        if (request.readyState == HttpRequest.DONE &&
            (request.status == 200 || request.status == 0)) {
          //if判断语句：注册是否成功，成功跳转到另一个url处，否则给出错误提示：该用户已经注册......
          if(request.responseText == 'success'){
            var router2 = new Router(useFragment: true);
            router2.root
              ..addRoute(
                  name: 'STeaSignUp', path: '/tea/signup/succeed', enter: SSignUp);
            querySelector('#SignUp_Tea_Btn').attributes['href'] =
                router2.url('STeaSignUp');
            router2.listen();
          }
          else{
            querySelector("#signuperror").text="该用户已注册，请更换用户名或班级";
          }
          //end 注册是否成功的if
        }
      });
      //post data to the server
      var url = "http://127.0.0.1:14080/teacher_signup";
      request.open("POST", url, async: false);
      request.send(jsonData); //perform the post

    }
    //else：两次密码不同，给出提示
    else{
      querySelector("#signuperror").text = "两次输入密码不同，请重新输入！";
    }
    //end 两次密码是否一致的if
  }
  //end 用户名和密码是否为空的if
}

/// 接受用户点击注册成功确定按钮的响应
/// 参数[event]是鼠标事件....
void ReturnSignIn(MouseEvent event) {
  //todo 隐藏注册界面和注册成功界面，显示登录界面
}

/// 返回任务完成情况的内容
Object FtaskContent() {
  //todo 根据在教师主界面中的任务情况的选择，从数据库中取出相应的学生数据并返回
}

/// 接受用户点击返回主界面按钮的响应
void ReturnTeacher(MouseEvent event) {
  //todo 隐藏当前界面，显示教师主界面
}

/// 接受用户点击提交作业按钮的响应
/// 参数[event]是鼠标事件....
void SubmitWork(MouseEvent event) {
  //todo 记录用户选择的单词数据，存入Json文件
  //todo 隐藏当前界面，显示确认单词界面
}

/// 返回选择单词的字符串
Object WordContent() {
  //todo 根据相应的Json文件，返回单词数据
}

/// 接受用户点击确认单词并发布作业的按钮的响应
/// 参数[event]是鼠标事件....
void ConfirmWord(MouseEvent event) {
  //todo 将相应的json文件中的数据写入数据库
  //todo 显示提交单词成功界面
}

/// 接受用户点击重新选择单词的按钮的响应
/// 参数[event]是鼠标事件....
void ReselectWord(MouseEvent event) {
  //todo 删除原来存放在json文件中的临时单词数据，
  //todo 隐藏该界面，显示布置任务界面
}

///学生界面函数

/// 返回学生界面学生姓名
Object stu_name_show() {
  //todo 根据登录情况显示学生姓名
}

/// 返回学生界面学生班级
Object stu_class_show() {
  //todo 根据登录情况显示学生班级
}

/// 返回学生界面第一个待完成任务名称
Object stu_task_one_show() {
  //todo 根据登录情况显示学生第一个待完成任务名称
}

/// 参数[event]是鼠标事件....
void stu_task_one(MouseEvent event) {
  //todo 记录用户是否选择此任务。
}

/// 返回学生界面第二个待完成任务名称
Object stu_task_two_show() {
  //todo 根据登录情况显示学生第二个待完成任务名称
}

/// 参数[event]是鼠标事件....
void stu_task_two(MouseEvent event) {
  //todo 记录用户是否选择此任务。
}

/// 参数[event]是鼠标事件....
void stu_review_word(MouseEvent event) {
  //todo 用户点击按钮开始复习单词的响应工作，要显示复习的界面，隐藏当前界面。调用选择任务函数，并且传递用户选择的任务值供以后的界面再次复习使用。
}

/// 参数[event]是鼠标事件....
void stu_test_word(MouseEvent event) {
  //todo 用户点击按钮开始测试的响应工作，要跳转到测试的界面，并隐藏当前界面。
}
//查看已完成任务界面函数
Object finished_task_one() {
  //todo 请求从数据库中获取并显示第一个已完成任务的名字
}

void finished_task_one_show(MouseEvent event) {
  //todo 用户点击开始在右侧界面显示第一个对应任务的完成情况。
}

Object finished_task_two() {
  //todo 请求从数据库中获取并显示第二个已完成任务的名字
}

void finished_task_two_show(MouseEvent event) {
  //todo 用户点击开始在右侧界面显示第二个对应任务的完成情况。
}

Object finished_task_three() {
  //todo 请求从数据库中获取并显示第三个已完成任务的名字
}

void finished_task_three_show(MouseEvent event) {
  //todo 用户点击开始在右侧界面显示第三个对应任务的完成情况。
}

/// 参数[event]是鼠标事件....
void finished_return(MouseEvent event) {
  //todo 用户点击按钮返回主页的响应工作，返回到学生首页，并隐藏当前界面。
}
//复习界面

/// 返回复习界面当前复习的单词为第几个的数据
Object review_now_num_show() {
  //todo 当前复习的单词为第几个的数据
}

/// 返回复习界面本次复习总共包含多少个单词
Object review_total_num_show() {
  //todo 请求获取显示当前复习总共包含多少个单词的数据
}

/// 返回复习界面现在复习的单词中文或者英文
Object review_word_show() {
  //todo 请求获取显示当前复习单词的中文或者英文数据
}

/// 参数[event]是鼠标事件....
void review_voice(MouseEvent event) {
  //todo 用户点击按钮播放单词发音的响应工作，播放一遍当前单词发音。
}

/// 参数[event]是鼠标事件....
void review_change(MouseEvent event) {
  //todo 用户点击按钮转换中英文的响应工作。
}

/// 参数[event]是鼠标事件....
void review_next(MouseEvent event) {
  //todo 用户点击按钮下一个单词的响应工作，要转换到下一个单词复习的界面，单词、音频以及中文值都要改变。并判断下一个单词是否为空，空的时候转到结果界面。
}

/// 参数[event]是鼠标事件....
void review_again(MouseEvent event) {
  //todo 用户点击按钮重新复习的响应工作，要转换到第一个单词复习的界面。
}

/// 参数[event]是鼠标事件....
void review_test(MouseEvent event) {
  //todo 用户点击按钮开始测试的响应工作，要转换到单词听写测试的界面，并隐藏该界面。
}
//测试界面
/// 返回测试界面当前测试的单词为第几个数据
Object test_now_num_show() {
  //todo 当前测试的单词为第几个数据
}

/// 返回测试界面当前测试总共单词个数
Object test_total_num_show() {
  //todo 请求获取本次测试总共有多少个单词
}

/// 返回测试界面单词中文选项一
Object test_option_one_show() {
  //todo 请求随机获取单词的中文意思或者正确的单词
}

/// 返回测试界面单词中文选项二
Object test_option_two_show() {
  //todo 请求随机获取单词的中文意思或者正确的单词
}

/// 返回测试界面单词中文选项三
Object test_option_three_show() {
  //todo 请求随机获取单词的中文意思或者正确的单词
}

/// 参数[event]是鼠标事件....
void test_submit(MouseEvent event) {
  //todo 用户点击按钮提交单词的响应工作，要保留用户提交的数据并判断正误，也要把数据写入数据库，并且转换到下一个单词听写测试的界面或者最终结果。
}

void test_voice_play() {
  //todo 默认打开一个听写单词界面即播放三遍单词音频
}
//结果界面
///返回学生听写对的单词个数
Object result_correct_num_show() {
  //todo 请求获取数据库中学生听写对的单词个数并返回
}

///返回学生听写错的单词以及中文
Object result_wrong_one_show() {
  //todo 请求获取数据库中学生听写错的第一个单词以及中文
}

///返回学生听写错的单词以及中文
Object result_wrong_two_show() {
  //todo 请求获取数据库中学生听写错的第二个单词以及中文
}

/// 参数[event]是鼠标事件....
void result_return(MouseEvent event) {
  //todo 用户点击按钮返回主页的响应工作，返回到学生首页，并隐藏当前界面。
}