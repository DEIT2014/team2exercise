// Copyright (c) 2016, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:html';
var TestWord;
void main() {
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