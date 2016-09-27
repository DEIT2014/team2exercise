import 'package:angular2/core.dart';
@Component(
    selector:'fruit_dictionary',
    styleUrls: const['dictionary_component.css'],
    templateUrl: 'dictionary_component.html')

class DictionaryComponent {
  var words = {
    'apple':'苹果',
    'banana':'香蕉',
    'orange':'橘子',
    'strawberry':'草莓',
    'watermelon':'西瓜',
    'litchi':'荔枝',
    'pear':'梨',
    'durian':'榴莲',
    'peach':'桃子',
    'grape':'葡萄'
  };
  String Translation = '';
  String Word = '';
  String ButtonText = '请输入单词';
  bool isButtonEnabled = false;

  //文本框中输入时，翻译结果初始化
  // 输入前后按钮内容的变化
  void inputWord(String word) {
    Word = word;
    if (word
        .trim()
        .isEmpty) {
      ButtonText = '请输入单词';
      isButtonEnabled = false;
    }
    else {
      Translation = '';
      ButtonText = '翻译';
      isButtonEnabled = true;
    }
  }

  //点击按钮时将值传入Translation
  void translateWord() {
    words.forEach((k, v) {
      if( Word=="$k".toUpperCase()||Word=="$k".toLowerCase())
      {Translation='$v';}
      if(Word=='$v') Translation="$k";

    });
    if(Translation=='')
    {Translation="敬请期待！";}
  }
}