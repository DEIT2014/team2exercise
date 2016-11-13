// Copyright (c) 2016, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:html';

String signin_username;//登录界面的用户名变量
String signin_password;//登录界面的密码变量
String signup_username;//注册界面的用户名变量
String signup_class;//注册界面的班级变量
String signup_password;//注册界面的密码变量
String signup_confirmpw;//注册界面确认密码的变量
var TestWord;
void main() {
  /// 登录界面
  signin_username=querySelector('#SignIn_Username');//输入用户名
  signin_password=querySelector('#SignIn_Password');//输入密码
  querySelector('#SignIn_Btn')
    ..text='登录'
    ..onClick.listen(SignIn);//用户登录按钮
  querySelector('#SignUp_Btn')
    ..text='注册'
    ..onClick.listen(SignuUp);//用户注册按钮

  /// 注册界面
  signup_username=querySelector('#SignUp_Username');//输入用户名
  signup_class=querySelector('#SignUp_Class');//输入班级
  signup_password=querySelector('#SignUp_Password');//输入密码
  signup_confirmpw=querySelector('#SignUp_ConfirmPW');//确认密码
  querySelector('#SignUp_Stu_Btn')
    ..text='学生注册'
    ..onClick.listen(StuSignUp);//学生注册按钮
  querySelector('#SignUp_Tea_Btn')
    ..text='教师注册'
    ..onClick.listen(TeaSignUp);//教师注册按钮

  /// 注册成功界面
  querySelector('#SucSignUp_Btn')
    ..text='确定'
    ..onClick.listen(ReturnSignIn);//返回登录界面按钮

  /// 教师主界面
  /// 待定

  /// 任务完成情况界面
  querySelector('#Ftask_Content')
    ..text=FtaskContent;// 任务完成情况
  querySelector('#Ftask_Btn')
    ..text='返回主界面'
    ..onClick.listen(ReturnTeacher);//返回教师主界面按钮

  /// 布置任务界面
  querySelector('#AssignWork_Btn')
    ..text='提交'
    ..onClick.listen(SubmitWork);// 提交作业按钮

  ///确认单词界面
  querySelector('#ConfirmWord_Show')
    ..text=WordContent;//选择的单词内容
  querySelector('#ConfirmWord_Confirm_Btn')
    ..text='确认'
    ..onClick.listen(ConfirmWord);//确认单词以及发布作业的按钮
  querySelector('#ConfirmWord_Reselect_Btn')
    ..text='重新选择'
    ..onClick.listen(ReselectWord);//重新选择单词按钮

  ///布置作业成功界面
  querySelector('#SucAssignWord_Btn')
    ..text='返回主界面'
    ..onClick.listen(ReturnTeacher);//返回教师主界面的按钮

  /// 学生界面
  querySelector('#stu_name')
      ..text= '';//向服务器请求读取数据库中学生姓名的数据
  querySelector('#stu_class')
    ..text= '';//向服务器请求读取数据库中学生班级的数据
  querySelector('#stu_task_one')
    ..text= '';//向服务器请求读取数据库中待完成任务1名称的数据
  querySelector('#stu_task_two')
    ..text= '';//向服务器请求读取数据库中待完成任务2名称的数据
  querySelector('#stu_review')
    ..text= '复习单词'
  ..onClick.listen(stu_review_word);
  querySelector('#stu_test')
    ..text= '开始测试'
    ..onClick.listen(stu_test_word);
  querySelector('#review_now_num')
    ..text= '';//显示当前复习的单词为第几个的数据
  querySelector('#review_total_num')
    ..text= '';//向服务器请求读取数据库中当前复习总共有几个单词
  querySelector('#review_word')
    ..text= '';//向服务器请求读取数据库中当前复习单词的中文或者英文
  querySelector('#review_voice')
    ..onClick.listen(review_voice);
  querySelector('#review_change')
  ..text='中英文切换'
    ..onClick.listen(review_change);
  querySelector('#review_next')
    ..text='下一个'
    ..onClick.listen(review_next);
  querySelector('#review_again')
    ..text='重新复习'
    ..onClick.listen(review_again);
  querySelector('#review_test')
    ..text='开始测试'
    ..onClick.listen(review_test);
  querySelector('#test_now_num')
    ..text= '';//显示当前测试的单词为第几个的数据
  querySelector('#test_total_num')
    ..text= '';//向服务器请求读取数据库中当前测试总共有几个单词
  TestWord = querySelector('#test_total_num').text;
  querySelector('#test_option_one')
    ..text= '';//向服务器请求读取数据库中随机的单词中文或者正确的单词中文
  querySelector('#test_option_two')
    ..text= '';//向服务器请求读取数据库中随机的单词中文或者正确的单词中文
  querySelector('#test_option_three')
    ..text= '';//向服务器请求读取数据库中随机的单词中文或者正确的单词中文
  querySelector('#test_submit')
    ..text='提交'
    ..onClick.listen(test_submit);
  querySelector('#result_correct_num')
    ..text= '';//向服务器请求读取数据库中正确单词个数
  querySelector('#result_wrong_one')
    ..text= '';//向服务器请求读取数据库中第一个错误单词的中英文
  querySelector('#result_wrong_two')
    ..text= '';//向服务器请求读取数据库中第二个错误单词的中英文
  querySelector('#result_return')
    ..text='返回主页'
    ..onClick.listen(result_return);

}

/// 用来接受用户点击登录按钮以后的响应工作
/// 参数[event]是鼠标事件....
void SignIn(MouseEvent event){
  //todo 记录输入的用户名和密码并与数据库进行比较，
  //todo 若对比成功，隐藏登录界面，显示教师或者学生界面（根据相应的标志值判断）
}

/// 用来接受用户点击注册按钮以后的响应工作
/// 参数[event]是鼠标事件....
void SignIn(MouseEvent event){
  //todo 隐藏登录界面，显示注册界面
}

/// 接受用户点击学生注册按钮的响应
/// 参数[event]是鼠标事件....
void StuSignUp(MouseEvent event){
  //todo 将数据写入数据库中的用户信息表，并将身份属性值设为stu
  //todo 显示注册成功界面
}

/// 接受用户点击教师注册按钮的响应
/// 参数[event]是鼠标事件....
void TeaSignUp(MouseEvent event){
  //todo 将数据写入数据库中的用户信息表，并将身份属性值设为tea
  //todo 显示注册成功界面
}

/// 接受用户点击注册成功确定按钮的响应
/// 参数[event]是鼠标事件....
void ReturnSignIn(MouseEvent event){
  //todo 隐藏注册界面和注册成功界面，显示登录界面
}

/// 返回任务完成情况的内容
SomeType FtaskContent(){
  //todo 根据在教师主界面中的任务情况的选择，从数据库中取出相应的学生数据并返回
}

/// 接受用户点击返回主界面按钮的响应
void ReturnTeacher(MouseEvent event){
  //todo 隐藏当前界面，显示教师主界面
}

/// 接受用户点击提交作业按钮的响应
/// 参数[event]是鼠标事件....
void SubmitWork(MouseEvent event){
  //todo 记录用户选择的单词数据，存入Json文件
  //todo 隐藏当前界面，显示确认单词界面
}

/// 返回选择单词的字符串
SomeType FtaskContent(){
  //todo 根据相应的Json文件，返回单词数据
}

/// 接受用户点击确认单词并发布作业的按钮的响应
/// 参数[event]是鼠标事件....
void ConfirmWord(MouseEvent event){
  //todo 将相应的json文件中的数据写入数据库
  //todo 显示提交单词成功界面
}

/// 接受用户点击重新选择单词的按钮的响应
/// 参数[event]是鼠标事件....
void ReselectWord(MouseEvent event){
  //todo 删除原来存放在json文件中的临时单词数据，
  //todo 隐藏该界面，显示布置任务界面
}

/// stu_review_word用来接受用户点击按钮开始复习单词的响应工作，要显示复习的界面。
/// 参数[event]是鼠标事件....
void stu_review_word(MouseEvent event) {
  //todo 在这里添加代码处理鼠标点击之后的工作。
}
/// stu_test_word用来接受用户点击按钮开始测试的响应工作，要跳转到测试的界面。
/// 参数[event]是鼠标事件....
void stu_test_word(MouseEvent event) {
  //todo 在这里添加代码处理鼠标点击之后的工作。
}
/// review_voice用来接受用户点击按钮播放单词发音的响应工作，播放一遍当前单词发音。
/// 参数[event]是鼠标事件....
void review_voice(MouseEvent event) {
  //todo 在这里添加代码处理鼠标点击之后的工作。
}
/// review_change用来接受用户点击按钮转换中英文的响应工作。
/// 参数[event]是鼠标事件....
void review_change(MouseEvent event) {
  //todo 在这里添加代码处理鼠标点击之后的工作。
}
/// review_next用来接受用户点击按钮下一个单词的响应工作，要转换到下一个单词复习的界面。
/// 参数[event]是鼠标事件....
void review_next(MouseEvent event) {
  //todo 在这里添加代码处理鼠标点击之后的工作。
}
/// review_again用来接受用户点击按钮重新复习的响应工作，要转换到第一个单词复习的界面。
/// 参数[event]是鼠标事件....
void review_again(MouseEvent event) {
  //todo 在这里添加代码处理鼠标点击之后的工作。
}
/// review_test用来接受用户点击按钮开始测试的响应工作，要转换到单词听写测试的界面。
/// 参数[event]是鼠标事件....
void review_test(MouseEvent event) {
  //todo 在这里添加代码处理鼠标点击之后的工作。
}
/// test_submit用来接受用户点击按钮提交单词的响应工作，要保留用户提交的数据并且转换到下一个单词听写测试的界面或者最终结果。
/// 参数[event]是鼠标事件....
void test_submit(MouseEvent event) {
  //todo 在这里添加代码处理鼠标点击之后的工作。
}
/// result_return用来接受用户点击按钮返回主页的响应工作，返回到学生首页。
/// 参数[event]是鼠标事件....
void result_return(MouseEvent event) {
  //todo 在这里添加代码处理鼠标点击之后的工作。
}