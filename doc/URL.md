URL     | 描述
-------- | ---
/student/index | 从学生待完成任务表中获取待完成任务信息
/review    | 从每个任务单词表中取出所有单词信息，包括每个单词的英文、中文以及发音
/test/get     | 从每个任务单词表中取出单词信息，包括中文以及发音
/result     | 从数据库任务完成情况表里面获取此次听写结果结果数据
/finished   | 从数据库中学生任务完成情况表1中获取相关数据（第几课时、日期、正确的单词和错误的单词）
/student_test/post | 将学生听写的单词写入数据库中并将判断的结果（正误）写入数据库中

URL     | 描述
-------- | ---
/userinfo | 从用户信息表中获取用户登录的信息，包括用户名、密码和身份属性
/teacher_viewtask    | 从testscore表中获取相关数据（姓名、正确几个、错误几个）
/teacher_writetask     | 将老师布置的任务数据写入任务表
/teacher_gettask   | 从任务表中取出数据

main.dart中的URL

URL   | 描述
-------- | ---
/signup  | 显示注册界面
/stu/index | 显示学生主页
/tea/index | 显示教师主页

