// Copyright (c) 2016, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:angular2/core.dart';
import 'dictionary_component.dart';
@Component(
    selector: 'my-app',
    styleUrls: const ['app_component.css'],
    templateUrl: 'app_component.html',
    directives: const[DictionaryComponent]
)
class AppComponent {}