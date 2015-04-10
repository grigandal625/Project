#coding=utf-8

MethodicalMaterial.create(
  name: 'Components',
  title: '<h1>Методические материалы</h1>',
  description: '<h3 class="aling-center">Уважаемые студенты!</h3>
                            <p class="lead text-center">Здесь собраны все методические указания для успешного выполнения практических заданий в&nbsp;лаборатории ИСиТ на&nbsp;третьем, четвертом и&nbsp;пятом курсах каф. Кибернетика НИЯУ МИФИ.</p>
                            <p class="lead text-center">Для того чтобы начать изучение материалов необходимо выбрать интересующую Вас тему на&nbsp;панели слева.</p>
                            <div class="row no-margin">
                                <div class="col-xs-3 col-xs-offset-9">
                                    <a href="#menu-toggle" class="btn btn-primary pull-right" id="menu-toggle">Активировать панель</a>
                                </div>
                            </div>')

MethodicalMaterial.create(
    name: 'Прямой вывод',
    title: '<h1>Методические материалы по практическим работам - Прямой вывод</h1>',
    description: '<h3 class="aling-center">Уважаемые студенты!</h3>
                            <p class="lead text-center">Здесь собраны методические указания для успешного выполнения <strong>компонента выявления умений моделировать стратегии прямого вывода</strong> в Научной лаборатории ИСиТ НИЯУ МИФИ.</p>
                            <div class="row no-margin">
                                <div class="col-md-offset-9 col-md-3"><a href="#menu-toggle" class="btn btn-primary pull-right" id="menu-toggle">Активировать панель</a></div>
                            </div>',
    theoretical_part: '
                                    <p class="indent">Рассмотрим пример &laquo;ручного вывода&raquo;,для фрагмента <span class="text-primary" data-toggle="tooltip" data-placement="top" title="База знаний">БЗ</span>, описывающего ситуацию &laquo;Покупка легкового автомобиля&raquo; в виде шести нижеприведенных правил, которые на естественном языке выглядят следующим образом:</p>

                                    <div class="row">
                                        <div class="col-md-10 col-md-offset-1">
                                            <table class="table table-hover">
                                                <tr>
                                                    <td>
                                                       <p class="indent-2">П.1. Если у человека много денег и ему удобно ездить на машине, то нужно ехать в автосалон.</p> 
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                       <p class="indent-2">П.2. Если у человека мало денег и ему нужен автомобиль, то нужно ехать на рынок подержанных автомобилей.</p> 
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                       <p class="indent-2">П.3. Если есть время и нужно ехать в автосалон, то необходимо определиться с маркой машины.</p> 
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <p class="indent-2">П.4. Если есть время и нужно ехать на авторынок, то необходимо определиться с пробегом покупаемой машины.</p>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <p class="indent-2">П.5. Если человек приехал в автосалон и определился с маркой, то нужно произвести покупку нового автомобиля.</p>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                         <p class="indent-2">П.6. Если человек приехал на авторынок и определился с пробегом, то нужно произвести покупку б/у автомобиля.</p>
                                                    </td>
                                                </tr>
                                            </table>
                                        </div>
                                    </div>

                                    <p class="indent">Используя упрощенную версию ЯПЗ системы Level5.Object, эти правила представляются в следующем виде.</p>

                                    <div class="row">
                                        <div class="col-md-10 col-md-offset-1">
                                            <table class="table table-hover">
                                                <tbody>
                                                    <tr>
                                                        <td>
                                                            <p class="indent-2"><code>RULE 1</code></p>
                                                            <p class="indent-2"><code>IF</code> <span class="label label-primary">Много денег</span> <code>= TRUE AND</code> <span class="label label-primary">Удобно ездить на авто</span> <code>= TRUE THEN</code> <span class="label label-primary">Ехать в автосалон</span> <code>:=TRUE</code></p>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                           <p class="indent-2"><code>RULE 2</code></p>
                                                            <p class="indent-2"><code>IF</code> <span class="label label-primary">Мало денег</span> <code>= TRUE AND</code> <span class="label label-primary">Нужен авто</span> <code>= TRUE THEN</code> <span class="label label-primary">ехать на авторынок</span> <code>:=TRUE</code></p> 
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                           <p class="indent-2"><code>RULE 3</code></p>
                                                            <p class="indent-2"><code>IF</code> <span class="label label-primary">Есть время</span> <code>= TRUE AND</code> <span class="label label-primary">Ехать на авторынок</span> <code>= TRUE THEN</code> <span class="label label-primary">Определиться с пробегом</span> <code>:=TRUE</code></p> 
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <p class="indent-2"><code>RULE 4</code></p>
                                                            <p class="indent-2"><code>IF</code> <span class="label label-primary">Есть время</span> <code>= TRUE AND</code> <span class="label label-primary">Ехать на авторынок</span> <code>= TRUE THEN</code> <span class="label label-primary">Определиться с пробегом</span> <code>:=TRUE</code></p>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <p class="indent-2"><code>RULE 5</code></p>
                                                            <p class="indent-2"><code>IF</code> <span class="label label-primary">Ехать в автосалон</span> <code>= TRUE AND</code> <span class="label label-primary">Определится с маркой</span> <code>= TRUE THEN</code> <span class="label label-primary">Покупать новый авто</span> <code>:=TRUE</code></p>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                           <p class="indent-2"><code>RULE 6</code></p>
                                                            <p class="indent-2"><code>IF</code> <span class="label label-primary">Ехать на авторынок</span> <code>= TRUE AND</code> <span class="label label-primary">Определится с пробегом</span> <code>= TRUE THEN</code> <span class="label label-primary">Покупать б/у авто</span> <code>:=TRUE</code></p> 
                                                        </td>
                                                    </tr>
                                                </tbody>
                                            </table>
                                        </div>
                                    </div>
                                    
                                    <p class="indent">Пусть от пользователя СОЗ(ЭС) в систему, т.е. в рабочую память, поступили следующие факты:</p>
                                    <p class="indent">Начальное состояние РП:</p>
                                    <ul>
                                        <li>"Много денег"</li>
                                        <li>"Удобно ездить на авто"</li>
                                        <li>"Есть время"</li>
                                    </ul>
                                    <p class="indent">Рассмотрим основные шаги алгоритмов прямого и обратного вывода.</p>
                                    <h4 class="text-center">Прямой вывод</h4>
                                    <p class="indent">В этом случае необходимо просматривать все правила и выбирать те, у которых выполняются условия, тем самым формируя конфликтное множество. Затем, используя махенизм разрешения конфликтов, выбирать подходящее правило, добавлять его заключение в рабочую память и т.д.</p>
                                    <p class="indent lead font-lg bg-danger">За один проход можно добавить в РП только один факт.</p>
                                    <div class="row">
                                        <div class="col-md-5 col-md-offset-1">
                                            <p><span class="label label-primary">Проход 1.</span> Осуществляется просмотр правил, ищется то, у которого выполняются все условия. После того как такое правило найдено, факт из его правой части, добавляетя в рабочую память, затем просматриваются все остальные правила, но со старой РП.</p>
                                           
                                        </div>
                                        <div class="col-md-5">
                                            <p><span class="label label-primary">Проход 2.</span> Выполняется аналогично первому, но с учетом того, что некоторые правила уже сработали, поэтому они пропускаются</p>

                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="col-md-5 col-md-offset-1">
                                             <table class="table table-hover">
                                                <tbody>
                                                    <tr>
                                                        <td>
                                                            <code>RULE 1</code> - подходит (в рабочую память добавляется новый факт "Ехать в автосалон")
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <code>RULE 2</code> - не подходит
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <code>RULE 3</code> - не подходит
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <code>RULE 4</code> - не подходит
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <code>RULE 5</code> - не подходит
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <code>RULE 6</code> - не подходит
                                                        </td>
                                                    </tr>
                                                </tbody>
                                            </table>
                                            
                                        </div>
                                        <div class="col-md-5">
                                            <table class="table table-hover">
                                                <tbody>
                                                    <tr>
                                                        <td>
                                                            <code>RULE 1</code> - не подходит или уже сработало
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <code>RULE 2</code> - не подходит
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <code>RULE 3</code> - подходит (в РП добавляется новый факт "Определиться с маркой")
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <code>RULE 4</code> - не подходит
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <code>RULE 5</code> - не подходит
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <code>RULE 6</code> - не подходит
                                                        </td>
                                                    </tr>
                                                </tbody>
                                            </table>
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="col-md-5 col-md-offset-1">
                                            <p><span class="label label-primary">Проход 3.</span> Выполняется аналогично второму.</p>
                                        </div>
                                        <div class="col-md-5">
                                            <p><span class="label label-primary">Проход 4.</span> Необходимо выполнить ещё один проход, чтобы показать, что ни одно правило не сработает.</p>
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="col-md-5 col-md-offset-1">
                                            <table class="table table-hover">
                                                <tbody>
                                                    <tr>
                                                        <td>
                                                            <code>RULE 1</code> - не подходит или уже сработало
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <code>RULE 2</code> - не подходит
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <code>RULE 3</code> - не подходит или уже сработало
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <code>RULE 4</code> - не подходит
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <code>RULE 5</code> - подходит  (в рабочую память добавляется новый факт "Покупать новый авто")
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <code>RULE 6</code> - не подходит
                                                        </td>
                                                    </tr>
                                                </tbody>
                                            </table>
                                        </div>
                                        <div class="col-md-5">
                                            <table class="table table-hover">
                                                <tbody>
                                                    <tr>
                                                        <td>
                                                            <code>RULE 1</code> - не подходит или уже сработало
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <code>RULE 2</code> - не подходит
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <code>RULE 3</code> - не подходит
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <code>RULE 4</code> - не подходит
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <code>RULE 5</code> - не подходит или уже сработало
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <code>RULE 6</code> - не подходит
                                                        </td>
                                                    </tr>
                                                </tbody>
                                            </table>
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="col-md-12">
                                            <p class="indent">Таким образом, получена рекомендация системы: "Покупать новый авто"</p>
                                        </div>
                                    </div>
                                    
                                    <div class="row">
                                        <div class="col-md-12">
                                            <p class="pull-right text-muted"><em>Источник: Рыбина Г.В. Основы построения интеллектуальных систем. Учебное пособие. – М.: Финансы и статистика; ИНФРА‑М, 2010. – 432с.</em></p>
                                        </div>
                                    </div>',
    practical_part: '<h4 class="text-center">Введение</h4>
                                            <p class="indent">В новой версии программы для разрешения конфликтов были применены коэфициенты определенности <span class="text-primary" data-toggle="tooltip" data-placement="top" title="ПЧП">правой части правила</span>.</p>
                                            <p class="indent lead font-lg bg-danger">Все конфликтные ситуации разрешаются путем выбора <span class="text-primary" data-toggle="tooltip" data-placement="top" title="подцели">правила</span> с наибольшим коэффициентом определенности.</p>
                                            <p class="indent">Для прохождения тестирования у вас будет <strong>ограниченное время</strong>:
                                                <ul>
                                                    <li>Прямой вывод - 7 минут</li>
                                                    <li>Обратный вывод - 8 минут</li>
                                                </ul>
                                            </p>
                                            <p class="indent">В правом верхнем углу всегда отображается справочная информация, которая будет исключать «в корне» неправильные действия.</p>
                                            <p class="indent">При прохождении прямого вывода у вас будет возможность редактирования и удаления шагов с трассы вывода, а при прохождении обратного вывода только удаление.</p>
                                            <p class="indent">Если у вас возник <span class="text-primary" data-toggle="tooltip" data-placement="top" title="неравенство коэффициентов">конфилкт коэффициентов</span>, то нужно выбрать тот, чей номер правила меньший.</p>
                                            <h4 class="text-center">Сценарий лабораторной работы</h4>
                                            <p class="indent">Первое, что вам необходимо сделать – авторизоваться <strong>по вашим</strong> логинам и паролям, которые вам предоставят инженеры кафедры.</p>
                                            <p class="text-center"><img class="img-thumbnail img-responsive" src="/assets/auth_po.png"></p>
                                            <p class="indent">После авторизации, вы получаете доступ к панели управления в режиме <span class="text-primary" data-toggle="tooltip" data-placement="top" title="режим реального времени">RunTime</span>.</p>
                                            <p class="text-center"><img class="img-thumbnail img-responsive" src="/assets/po.png"></p>
                                            <p class="indent">Далее, вам надо нажать на ссылку <span class="label label-default">Прямой вывод</span> или <span class="label label-default">Обратный вывод</span>. Вам откроется таблица с вашими результатами.</p>
                                            <p class="indent">Далее нажимаете на ссылку <span class="label label-default">Пройти тестирование</span> и проходите тестирование выбранного вами вывода.</p>
                                            <h4 class="text-center">Прохождение прямого вывода</h4>
                                            <p class="indent">При запуске тестирования ваша база сохранится на сервере, и вам откроется окно <span class="label label-primary">Выбор начального состояния</span>.</p>
                                            <p class="indent lead font-lg bg-danger">Также предупреждаем, что попытка прохождения тестирования после начала прохождения исчерпается.</p>
                                            <p class="indent">В окне вам нужно указать факты, которые должны быть в начальной <span class="text-primary" data-toggle="tooltip" data-placement="top" title="рабочей памяти">РП</span>. Указывать их нужно обоснованно. То есть вы должны указывать факты, которые находятся на <span class="text-primary" data-toggle="tooltip" data-placement="top" title="первая колонка слева">самом нижнем уровне</span>.</p>
                                            <p class="indent">При неправильных действиях, по выбору начальной РП в правом углу будут появлятся уведомления и методы решения проблемы.</p>
                                            <p class="indent">При успехе данного этапа у вас появится примерно такая картина (здесь в <span class="text-primary" data-toggle="tooltip" data-placement="top" title="рабочая память">РП</span> добавили 4 факта <code>Q,R,S,T</code>) (старая версия программы, в новой у вас откроется ваша модель, с указанием коэффициентов определенности <span class="text-primary" data-toggle="tooltip" data-placement="top" title="правая часть правила">ПЧП</span>)</p>
                                            <p class="text-center"><img class="img-thumbnail img-responsive" src="/assets/po1.png"></p>
                                            <p class="indent">Далее вы должны выбирать правила, которые <span class="text-primary" data-toggle="tooltip" data-placement="top" title="наличие всех фактов в зеленом фоне слева">могут сработать</span>. Для данного примера это например правило <code>R1</code></p>
                                            <p class="text-center"><img class="img-thumbnail img-responsive" src="/assets/po2.png"> с выбранным правилом R1</p>
                                            <p class="indent">Для того, чтобы выбрать правило нажмите на желтый круг для данного правила, вам откроется окно изменения состояния. При срабатывании правила вам нужно будет указать изменения в <span class="text-primary" data-toggle="tooltip" data-placement="top" title="рабочая память">РП</span>, для данного случая(срабатывание правила <code>R1</code>) это будет факт <code>J</code>, поэтому мы его указываем:</p>
                                            <p class="text-center"><img class="img-thumbnail img-responsive" src="/assets/po3.png"></p>
                                            <p class="indent">Также в данном окне вам необходимо выбрать состояние правил. Поскольку это первый проход у нас будет подходить только первое правило, остальные не подходят. Нажимаете на кнопку <span class="label label-default">Готово</span>.</p>
                                            <p class="indent lead font-lg bg-danger">В вашей версии программы с приминением коэффициентов определенности нужно выбирать не любое правило, а то, которое может сработать в данный момент и имеет <strong>наибольший</strong> коэффициент определенности <span class="text-primary" data-toggle="tooltip" data-placement="top" title="правая часть правила">ПЧП</span>. Учитываются <strong>все правила</strong> дерева.</p>
                                            <p class="text-center"><img class="img-thumbnail img-responsive" src="/assets/po4.png"></p>
                                            <p class="indent">Ваш шаг отобразится на трассе вывода.</p>
                                            <p class="indent">Далее проходите все шаги прямого метода, затем нажимаете оценить. Вам покажется ваша оценка. Затем переходите в панель управления для прохождения обратного вывода.</p>
                                            <p class="indent lead font-lg bg-danger">При шагах > 1 не забывайте, что правила, которые на данный момент были выполненны, должны иметь состояние «уже используется».</p>
                                            <h4 class="text-center">Будьте внимательны, и&nbsp;удачи!</h4>
                                    ')

########################################### 2 #########################################################

MethodicalMaterial.create(
    name: 'Обратный вывод',
    title: '<h1>Обратный вывод</h1>',
    description: '<h3 class="aling-center">Уважаемые студенты!</h3>
                            <p class="lead text-center">Здесь собраны методические указания для успешного выполнения <strong>компонента выявления умений моделировать стратегии обратного вывода</strong> в Научной лаборатории ИСиТ НИЯУ МИФИ.</p>',
    theoretical_part: '<p class="indent">Рассмотрим пример &laquo;ручного вывода&raquo;,для фрагмента <span class="text-primary" data-toggle="tooltip" data-placement="top" title="База знаний">БЗ</span>, описывающего ситуацию &laquo;Покупка легкового автомобиля&raquo; в виде шести нижеприведенных правил, которые на естественном языке выглядят следующим образом:</p>

                                    <div class="row">
                                        <div class="col-md-10 col-md-offset-1">
                                            <table class="table table-hover">
                                                <tr>
                                                    <td>
                                                       <p class="indent-2">П.1. Если у человека много денег и ему удобно ездить на машине, то нужно ехать в автосалон.</p> 
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                       <p class="indent-2">П.2. Если у человека мало денег и ему нужен автомобиль, то нужно ехать на рынок подержанных автомобилей.</p> 
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                       <p class="indent-2">П.3. Если есть время и нужно ехать в автосалон, то необходимо определиться с маркой машины.</p> 
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <p class="indent-2">П.4. Если есть время и нужно ехать на авторынок, то необходимо определиться с пробегом покупаемой машины.</p>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <p class="indent-2">П.5. Если человек приехал в автосалон и определился с маркой, то нужно произвести покупку нового автомобиля.</p>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                         <p class="indent-2">П.6. Если человек приехал на авторынок и определился с пробегом, то нужно произвести покупку б/у автомобиля.</p>
                                                    </td>
                                                </tr>
                                            </table>
                                        </div>
                                    </div>

                                    <p class="indent">Используя упрощенную версию ЯПЗ системы Level5.Object, эти правила представляются в следующем виде.</p>

                                    <div class="row">
                                        <div class="col-md-10 col-md-offset-1">
                                            <table class="table table-hover">
                                                <tbody>
                                                    <tr>
                                                        <td>
                                                            <p class="indent-2"><code>RULE 1</code></p>
                                                            <p class="indent-2"><code>IF</code> <span class="label label-primary">Много денег</span> <code>= TRUE AND</code> <span class="label label-primary">Удобно ездить на авто</span> <code>= TRUE THEN</code> <span class="label label-primary">Ехать в автосалон</span> <code>:=TRUE</code></p>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                           <p class="indent-2"><code>RULE 2</code></p>
                                                            <p class="indent-2"><code>IF</code> <span class="label label-primary">Мало денег</span> <code>= TRUE AND</code> <span class="label label-primary">Нужен авто</span> <code>= TRUE THEN</code> <span class="label label-primary">ехать на авторынок</span> <code>:=TRUE</code></p> 
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                           <p class="indent-2"><code>RULE 3</code></p>
                                                            <p class="indent-2"><code>IF</code> <span class="label label-primary">Есть время</span> <code>= TRUE AND</code> <span class="label label-primary">Ехать на авторынок</span> <code>= TRUE THEN</code> <span class="label label-primary">Определиться с пробегом</span> <code>:=TRUE</code></p> 
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <p class="indent-2"><code>RULE 4</code></p>
                                                            <p class="indent-2"><code>IF</code> <span class="label label-primary">Есть время</span> <code>= TRUE AND</code> <span class="label label-primary">Ехать на авторынок</span> <code>= TRUE THEN</code> <span class="label label-primary">Определиться с пробегом</span> <code>:=TRUE</code></p>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <p class="indent-2"><code>RULE 5</code></p>
                                                            <p class="indent-2"><code>IF</code> <span class="label label-primary">Ехать в автосалон</span> <code>= TRUE AND</code> <span class="label label-primary">Определится с маркой</span> <code>= TRUE THEN</code> <span class="label label-primary">Покупать новый авто</span> <code>:=TRUE</code></p>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                           <p class="indent-2"><code>RULE 6</code></p>
                                                            <p class="indent-2"><code>IF</code> <span class="label label-primary">Ехать на авторынок</span> <code>= TRUE AND</code> <span class="label label-primary">Определится с пробегом</span> <code>= TRUE THEN</code> <span class="label label-primary">Покупать б/у авто</span> <code>:=TRUE</code></p> 
                                                        </td>
                                                    </tr>
                                                </tbody>
                                            </table>
                                        </div>
                                    </div>
                                    
                                    <p class="indent">Рассмотрим основные шаги алгоритмов прямого и обратного вывода.</p>
                                    <h4 class="text-center">Обратный вывод</h4>
                                    <p class="indent">Здесь при просмотре правил необходимо искать то, у которого выдвинутая гипотеза (цель) находится в правой части. Затем, найдя такое правило, проверять наличиего условий из левой части в рабочей памяти. Если какого-либо условия там нет, то оно становится новой подцелью на текущей итерации (подцели выстраиваются в виде стека, т.е. при подтверждении послдней из них происходит возврат к предыдущей).</p>
                                    <p class="indent">Пусть выдвинута гипотеза (цель) "Покупка б/у авто".</p>
                                    <p class="indent">Начальное состояние РП:</p>
                                    <ul>
                                        <li>"Мало денег"</li>
                                        <li>"Нужен"</li>
                                        <li>"Есть время"</li>
                                    </ul>
                                    <div class="row">
                                        <div class="col-md-5 col-md-offset-1">
                                            <p><span class="label label-primary">Проход 1.</span> Просматриваются все правила, ищется цель "Покупать б/у авто" в правой части.</p>
                                        </div>
                                        <div class="col-md-5">
                                            <p><span class="label label-primary">Проход 2.</span> Ищется новая подцель "Ехать на авторынок" в правой части.</p>
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="col-md-5 col-md-offset-1">
                                             <table class="table table-hover">
                                                <tbody>
                                                    <tr>
                                                        <td>
                                                            <code>RULE 1</code> - не подходит
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <code>RULE 2</code> - не подходит
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <code>RULE 3</code> - не подходит
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <code>RULE 4</code> - не подходит
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <code>RULE 5</code> - не подходит
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <code>RULE 6</code> - подходит - новая подцель "Ехать на авторынок"
                                                        </td>
                                                    </tr>
                                                </tbody>
                                            </table>
                                            
                                        </div>
                                        <div class="col-md-5">
                                            <table class="table table-hover">
                                                <tbody>
                                                    <tr>
                                                        <td>
                                                            <code>RULE 1</code> - не подходит
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <code>RULE 2</code> - подходит (в рабочую память добавляется новый факт "Ехать на авторынок", все условия из левой части есть в РП, правило достоверно, пополняется РП, и так как подцель уже подтвержилась, последующие правила не повторяются)
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            Новое состояние РП: "Мало денег","Нужен авто", "Есть время", "Ехать на авторынок"
                                                        </td>
                                                    </tr>
                                                </tbody>
                                            </table>
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="col-md-5 col-md-offset-1">
                                            <p><span class="label label-primary">Проход 3.</span> Выполняется для предыдущей подцели, которая в данном случае является главной - "Покупать б/у авто".</p>
                                        </div>
                                        <div class="col-md-5">
                                            <p><span class="label label-primary">Проход 4.</span> Ищется новая подцель "Определиться с пробегом" в правой части.</p>
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="col-md-5 col-md-offset-1">
                                            <table class="table table-hover">
                                                <tbody>
                                                    <tr>
                                                        <td>
                                                            <code>RULE 1</code> - не подходит
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <code>RULE 2</code> - не подходит
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <code>RULE 3</code> - не подходит
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <code>RULE 4</code> - не подходит
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <code>RULE 5</code> - не подходит
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <code>RULE 6</code> - подходит - новая поцдель "Определиться с пробегом"
                                                        </td>
                                                    </tr>
                                                </tbody>
                                            </table>
                                        </div>
                                        <div class="col-md-5">
                                            <table class="table table-hover">
                                                <tbody>
                                                    <tr>
                                                        <td>
                                                            <code>RULE 1</code> - не подходит
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <code>RULE 2</code> - не подходит
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <code>RULE 3</code> - не подходит
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <code>RULE 4</code> - подходит (в рабочую память добавляется факт "Определиться с пробегом", все условия из левой части есть в РП, правило достоверно, пополняется РП)
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                           Новое состояние РП: "Мало денег","Нужен авто", "Есть время", "Ехать на авторынок", "Определиться с пробегом"
                                                        </td>
                                                    </tr>
                                                </tbody>
                                            </table>
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="col-md-6 col-md-offset-3">
                                            <p><span class="label label-primary">Проход 5.</span> Выполняется для цели "Покупать б/у авто".</p>
                                            <table class="table table-hover">
                                                <tbody>
                                                    <tr>
                                                        <td>
                                                            <code>RULE 1</code> - не подходит
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <code>RULE 2</code> - не подходит
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <code>RULE 3</code> - не подходит
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <code>RULE 4</code> - не подходит
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <code>RULE 5</code> - не подходит
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <code>RULE 6</code> - подходит (в рабочую память добавляется новый факт "Покупать б/у авто", все условия есть в РП)
                                                        </td>
                                                    </tr>
                                                </tbody>
                                            </table>
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="col-md-12">
                                            <p class="indent">Таким, образом, основная гипотеза подтвердилась, факты достоверны, цель достигнута</p>
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="col-md-12">
                                           <p class="pull-right text-muted"><em>Источник: Рыбина Г.В. Основы построения интеллектуальных систем. Учебное пособие. – М.: Финансы и статистика; ИНФРА‑М, 2010. – 432с.</em></p>
                                        </div>
                                    </div>',
    practical_part: '
                          
                                      
                                            <h4 class="text-center">Введение</h4>
                                            <p class="indent">В новой версии программы для разрешения конфликтов были применены коэфициенты определенности <span class="text-primary" data-toggle="tooltip" data-placement="top" title="ПЧП">правой части правила</span>.</p>
                                            <p class="indent lead font-lg bg-danger">Все конфликтные ситуации разрешаются путем выбора <span class="text-primary" data-toggle="tooltip" data-placement="top" title="подцели">правила</span> с наибольшим коэффициентом определенности.</p>
                                            <p class="indent">Для прохождения тестирования у вас будет <strong>ограниченное время</strong>:
                                                <ul>
                                                    <li>Прямой вывод - 7 минут</li>
                                                    <li>Обратный вывод - 8 минут</li>
                                                </ul>
                                            </p>
                                            <p class="indent">В правом верхнем углу всегда отображается справочная информация, которая будет исключать «в корне» неправильные действия.</p>
                                            <p class="indent">При прохождении прямого вывода у вас будет возможность редактирования и удаления шагов с трассы вывода, а при прохождении обратного вывода только удаление.</p>
                                            <p class="indent">Если у вас возник <span class="text-primary" data-toggle="tooltip" data-placement="top" title="неравенство коэффициентов">конфилкт коэффициентов</span>, то нужно выбрать тот, чей номер правила меньший.</p>
                                            <h4 class="text-center">Сценарий лабораторной работы</h4>
                                            <p class="indent">Первое, что вам необходимо сделать – авторизоваться <strong>по вашим</strong> логинам и паролям, которые вам предоставят инженеры кафедры.</p>
                                            <p class="text-center"><img class="img-thumbnail img-responsive" src="/assets/auth_po.png"></p>
                                            <p class="indent">После авторизации, вы получаете доступ к панели управления в режиме <span class="text-primary" data-toggle="tooltip" data-placement="top" title="режим реального времени">RunTime</span>.</p>
                                            <p class="text-center"><img class="img-thumbnail img-responsive" src="/assets/po.png"></p>
                                            <p class="indent">Далее, вам надо нажать на ссылку <span class="label label-default">Прямой вывод</span> или <span class="label label-default">Обратный вывод</span>. Вам откроется таблица с вашими результатами.</p>
                                            <p class="indent">Далее нажимаете на ссылку <span class="label label-default">Пройти тестирование</span> и проходите тестирование выбранного вами вывода.</p>
                                            <h4 class="text-center">Прохождение обратного вывода</h4>
                                            <p class="indent">Выбираем в панели управления прохождение обратного вывода. Открывается окно <span class="label label-primary">Выбор начального состояния</span>.</p>
                                            <p class="text-center"><img class="img-thumbnail img-responsive" src="/assets/op.png"></p>
                                            <p class="indent lead font-lg bg-danger">Также предупреждаем, что попытка прохождения тестирования после начала прохождения исчерпается.</p>
                                            <p class="indent">Здесь вам нужно указать начальное состояние <span class="text-primary" data-toggle="tooltip" data-placement="top" title="рабочей памяти">РП</span> и выбрать основную цель.</p>
                                            <p class="indent lead font-lg bg-danger">Не забывайте про то, что начальное состояние <span class="text-primary" data-toggle="tooltip" data-placement="top" title="рабочей памяти">РП</span> нужно выбирать с самого нижнего уровня слева, а основную цель с самого высокого справа.</p>
                                            <p class="indent">В примере получится вот такая картина, после нажатия на кнопку <span class="label label-default">готово</span>.</p>
                                            <p class="text-center"><img class="img-thumbnail img-responsive" src="/assets/op2.png"></p>
                                            <p class="indent">Для получения положительной оценки, вам нужно найти правило, к которому принадлежит основная цель. В нашем случае это правило <code>R12</code>, смотрим какие факты нам необходимы для возможности срабатывания данного правила</p>
                                            <p class="text-center"><img class="img-thumbnail img-responsive" src="/assets/op3.png"> с выбранным правилом R1</p>
                                            <p class="indent">По примеру получается <code>F(0.91)</code> и <code>G(0.05)</code>. Но на данный момент в <span class="text-primary" data-toggle="tooltip" data-placement="top" title="рабочей памяти">РП</span> нету ни одного факта, для выполнения правила <code>R12</code>.</p>
                                            <p class="text-center"><img class="img-thumbnail img-responsive" src="/assets/po3.png"></p>
                                            <p class="indent lead font-lg bg-danger">В вашей версии программы с приминением коэффициентов определенности нужно выбирать не любую подцель , а ту, которая  имеет НАИБОЛЬШИЙ коэффициент определенности <span class="text-primary" data-toggle="tooltip" data-placement="top" title="правая часть правила">ПЧП</span>.</p>
                                            <p class="indent">Для этого нажмите, на факт <code>F</code> (так как по примеру его коэффициент определенности больше чем у <code>G</code>) и подтвердите создание поддцели.</p>
                                            <p class="text-center"><img class="img-thumbnail img-responsive" src="/assets/op4.png"></p>
                                            <p class="indent">По примеру получается вот так.</p>
                                            <p class="text-center"><img class="img-thumbnail img-responsive" src="/assets/op5.png"></p>
                                            <p class="indent">Опять смотрим наличие фактов в <span class="text-primary" data-toggle="tooltip" data-placement="top" title="рабочей памяти">РП</span> для срабатывания правила <code>R9</code>. Опять их нет в <span class="text-primary" data-toggle="tooltip" data-placement="top" title="рабочей памяти">РП</span>, поэтому выберем один из фактов правила <code>R9</code>, например факт <code>К</code> (допустим у него самый максимальный коэффициент определенности) сделаем текущей подцелью.</p>
                                            <p class="text-center"><img class="img-thumbnail img-responsive" src="/assets/op6.png"></p>
                                            <p class="indent">Правило <code>R2</code> при факте <code>К</code> может выполнится поэтому мы его выполняем <strong>сразу</strong>. Нажимаем на желтый круг <code>R2</code>, откроется окно</p>
                                            <p class="text-center"><img class="img-thumbnail img-responsive" src="/assets/op7.png"></p>
                                            <p class="indent">Здесь есть несколько ключевых моментов. Во первых вам надо указать изменение <span class="text-primary" data-toggle="tooltip" data-placement="top" title="рабочей памяти">РП</span>, по примеру нужно добавить <code>К</code> изменение <span class="text-primary" data-toggle="tooltip" data-placement="top" title="рабочей памяти">РП</span>, а также указать факт <code>К</code> как сработанную подцель и еще указать состояние правил.</p>
                                            <p class="indent">После нажатия на кнопку готово, все действия на данном шаге покажутся на трассе вывода, а также вы вернетесь по стеку на одну подцель назад.</p>
                                            <p class="text-center"><img class="img-thumbnail img-responsive" src="/assets/op8.png"></p>
                                            <p class="indent">Смотрим опять правило <code>R9</code>, у него не хватает фактов для выполнения, значит опять выбираем подцель, например факт <code>M</code></p>
                                            <p class="text-center"><img class="img-thumbnail img-responsive" src="/assets/op9.png"></p>
                                            <p class="indent">Так вы делаете все действия, пока не добьетесь ситуации, в которой все факты правила основной подцели будут в РП. По примеру должно быть наличие фактов <code>F</code> и <code>G</code>. Последним шагом будет срабатывание правила  <code>R12</code> (по примеру) с указанием изменения РП факта А, срабатывание подцели А, а также все состояния правил.</p>
                                            <p class="indent lead font-lg bg-danger">Если вы выбрали подцель и правило данной подцели может выполнится – вы должны его выполнить сразу, если правило не может выполнится - вы должны выбрать новую подцель из фактов данного правила(которых нет в РП) иначе вы можете получить плохую оценку.</p>
                                            <p class="indent">Любое изменение текущей подцели заносит ее в <span class="text-primary" data-toggle="tooltip" data-placement="top" title="«последним пришёл — первым вышел»">стек</span>. Поэтому при срабатывания какого-нибудь правила подцель автоматически вернется на предыдущую подцель.</p>
                                            <h4 class="text-center">Будьте внимательны, и&nbsp;удачи!</h4>')




























########################################### 3 #########################################################

MethodicalMaterial.create(
    name: 'Семантические сети',
    title: '<h1>Семантические сети</h1>',
    description: '<h3 class="aling-center">Уважаемые студенты!</h3>
    <p class="lead text-center">Здесь собраны методические указания для успешного выполнения <strong>компонента выявления умений моделировать простейшие ситуации проблемной области с помощью семантических сетей</strong> в Научной лаборатории ИСиТ НИЯУ МИФИ.</p>',
    theoretical_part: '<p class="indent">Понятие семантической сетибыло впервые введено М. Куиллианом в конце 1960-х гг. и с тех пор активно используется в ИИ. Прибольшом разноорбразии трактовок и определений суть это модели остается неизменной - под семантической сетью понимается <em>неоднородная сеть</em>, т.е. сеть с различными типами вершин и различными типами помеченных дуг.</p>

                                    <div class="row">
                                        <div class="col-md-8 col-md-offset-2">
                                             <table class="table table-striped table-bordered">
                                                <caption class="text-center">Перечень упрощенных семантико-синтаксических связей</caption>
                                                <thead>
                                                    <tr>
                                                        <th>Тип связи</th>
                                                        <th>Разновидность связи и&nbsp;ее&nbsp;обозначение</th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <tr>
                                                        <td>Глубинный падеж (семантическая валентность)</td>
                                                        <td>
                                                        <code>A</code> &mdash;&nbsp;быть &laquo;агентом&raquo; действия<br>
                                                        <code>O</code> &mdash;&nbsp;быть &laquo;объектом&raquo; действия<br>
                                                        <code>D</code> &mdash;&nbsp;быть &laquo;адресатом&raquo; действия<br>
                                                        <code>T</code> &mdash;&nbsp;быть &laquo;темой&raquo; действия<br>
                                                        <code>I</code> &mdash;&nbsp;быть &laquo;инструментом&raquo; действия<br>
                                                        <code>L</code> &mdash;&nbsp;быть &laquo;местом&raquo; действия<br>
                                                        <code>S</code> &mdash;&nbsp;быть &laquo;начальной точкой&raquo; действия<br>
                                                        <code>F</code> &mdash;&nbsp;быть &laquo;конечной точкой&raquo; действия<br>
                                                        <code>G</code> &mdash;&nbsp;быть &laquo;целью&raquo; действия<br>
                                                        <code>C</code> &mdash;&nbsp;быть &laquo;условием&raquo; действия<br>
                                                        <code>W</code> &mdash;&nbsp;быть &laquo;временем&raquo; действия<br>
                                                        <code>M</code> &mdash;&nbsp;быть &laquo;способом&raquo; действия<br>
                                                        <code>B</code> &mdash;&nbsp;быть &laquo;сроком&raquo; действия<br>
                                                        <code>X</code> &mdash;&nbsp;быть &laquo;количеством&raquo; действия<br>
                                                        <code>R</code> &mdash;&nbsp;быть &laquo;результатом&raquo; действия<br>
                                                        <code>K</code> &mdash;&nbsp;быть &laquo;контрагентом&raquo; действия<br>
                                                        </td>
                                                    </tr>
                                                </tbody>
                                            </table>
                                        </div>
                                        <div class="col-md-12">
                                            <p class="pull-right text-muted"><em>Источник: Рыбина Г.В. Основы построения интеллектуальных систем. Учебное пособие. – М.: Финансы и статистика; ИНФРА‑М, 2010. – 432с.</em></p>
                                        </div></div>',
    practical_part: '<h4 class="text-center">Введение</h4>
                                            <p class="indent">После авторизации перед вами откроется окно с выбором практических заданий.</p>
                                            <p class="text-center"><img class="img-thumbnail img-responsive" src="/assets/ling.png"></p>
                                            <p class="indent">Выбираем ссылку <span class="label label-default">Семантические сети</span>. Задание будет выбрано случайным образом.</p>
                                            <p class="indent">После выбора системой задания для вас, перед вами будет окно с вариантом вашего задания.</p>
                                            <p class="text-center"><img class="img-thumbnail img-responsive" src="/assets/task_sem_network.png"></p>
                                            <p class="indent">Перед тем как приступать к заданию, ознакомьтесь с интерфейсом. Обратите внимание на возможные действия выполняемые над вершинами сети, научить создавать связи, после чего приступайте к заданию.</p>
                                            <p class="indent">Рассмотрим пример вашего задания "Покупка стиральной машины". Прежде всего необходимо выбрать предикат. Для того чтобы выбрать предикат нужно кликнуть на левый квадратик располагаемый внутри вершины.</p>
                                            <p class="text-center"><img class="img-thumbnail img-responsive" src="/assets/predic_sem_network.png"></p>
                                            <p class="indent">Далее можно начинать указывать связи между вершинами.</p>
                                            <p class="indent lead font-lg bg-danger">Будьте внимательны! Глубинные падежи узказываются <strong>английскими</strong> заглавными буквами.</p>
                                            <p class="text-center"><img class="img-thumbnail img-responsive" src="/assets/rel_sem_network.png"></p>
                                            <p class="indent">После того как выполните задание нужно нажать на кнопку <span class="label label-primary">Готово</span> система сообщит вам ваш результат. Также можно будет нажать на кнопку <span class="label label-primary">Ошибки</span>, чтобы ознакомится с совершенными ошибками, если такие имеются.</p>
                                            <p class="text-center"><img class="img-thumbnail img-responsive" src="/assets/panel_sem_network.png"></p>
                                            <p class="indent lead font-lg bg-danger">Хочется отметить, что не всегда в вашей сети будут задействованы все предоставленные вершины.</p>
                                            <p class="text-center"><img class="img-thumbnail img-responsive" src="/assets/doing_sem_network.png"></p>
                                            <h4 class="text-center">Будьте внимательны, и&nbsp;удачи!</h4>')



























########################################### 4 #########################################################

MethodicalMaterial.create(
    name: 'Фреймы',
    title: '<h1>Сетевые модели представления знаний: фреймы</h1>',
    description: '<h3 class="aling-center">Уважаемые студенты!</h3>
                            <p class="lead text-center">Здесь собраны методические указания для успешного выполнения <strong>компонента выявления умений моделировать простейшие ситуации проблемной области с помощью фреймов</strong> в Научной лаборатории ИСиТ НИЯУ МИФИ.</p>',
    theoretical_part: '<p class="indent">Термин &laquo;фрейм&raquo;, который в&nbsp;ранних работах по&nbsp;ИИ переводился как &laquo;скелет&raquo;, &laquo;ситуационная рамка&raquo;, &laquo;каркас&raquo; и&nbsp;т.д., стал популярным после выхода в&nbsp;свет в&nbsp;начале 1970-х гг. знаменитой работы М.Минского, где фрейм определяется как &laquo;структура данных для отображения стереотипной ситуации&raquo;, т.е. некоторое формализованное знание о&nbsp;<span class="text-primary" data-toggle="tooltip" data-placement="top" title="стандартной">стереотипной</span> ситуации <span class="text-primary" data-toggle="tooltip" data-placement="top" title="Проблемной области">ПрО</span>.</p>
                                    <p class="indent">С&nbsp;точки зрения модельного аспекта фрейм&nbsp;&mdash; это сеть, у&nbsp;которой одна часть всегда заполнена, а&nbsp;другая содержит незаполненные подструктуры-слоты. Иными словами, фиксируются постоянные имена <span class="text-primary" data-toggle="tooltip" data-placement="top" title="ролей">актантов</span> ситуации, описываемой фреймом,&nbsp;&mdash; это имена <span class="text-primary" data-toggle="tooltip" data-placement="top" title="подструктур фрейма">слотов</span>, а&nbsp;значения слотов определяются в&nbsp;зависимости от&nbsp;выполнения условий/требований к&nbsp;каждому <span class="text-primary" data-toggle="tooltip" data-placement="top" title="роли">актанту</span> ситуации.</p>
                                    <p class="indent">Эти условия могутбыть заданы самым разнообразным способом, включая использование привязанных процедур, умолчаний, имен других фреймов, множественных ссылок и&nbsp;т.д. Во&nbsp;фреймах допускается рекурсивное фложение слотов друг в&nbsp;друга, что может пораждать иерархическую структуру взаимосвязанных слотов и&nbsp;фреймов.</p>
                                    <p class="indent">В&nbsp;общем случае, используя теоретико-множественное представление, фрейм <code>(F)</code> может быть описан в&nbsp;виде следующей конструкции:</p>
                                    <p class="text-center"><code><em>F = &lt;N,a<sub>1</sub> b<sub>1</sub> [P<sub>1</sub>], a<sub>2</sub> b<sub>2</sub> [P<sub>2</sub>], ..., a<sub>n</sub> b<sub>n</sub> [P<sub>n</sub>]&gt;</em></code>,</p>
                                    <div class="row">
                                        <div class="col-md-1">
                                            <p class="pull-right">где</p>
                                        </div>
                                        <div class="col-md-4">
                                                <ul>
                                                    <li><code><em>N</em></code> &mdash; имя фрейма;</li>
                                                    <li><code><em>a<sub>i</sub></em></code> &mdash; имя <em>i</em>-слота;</li>
                                                    <li><code><em>b<sub>i</sub></em></code> &mdash; значение <em>i</em>-слота;</li>
                                                    <li><code><em>[P<sub>i</sub>]</em></code> &mdash; процедура, привязанная к <em>i</em>-слоту (опционально);</li>
                                                </ul>
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="col-md-12">
                                            <p class="indent lead font-lg bg-info">Важно, что в качестве значений слотов могут выступать имена других фреймов, что обеспечивает связь между ними.</p>
                                            <p class="indent">Обычно выделяют фреймы-<em>прототипы</em>, хранящиеся в <span class="text-primary" data-toggle="tooltip" data-placement="top" title="База знаний">БЗ</span>, и фреймы-<em>экземпляры</em>, которые создаются на основе фреймов-прототипов для отображения конкретных ситуаций на основе поступающих данных.</p>
                                            <p class="indent">Ниже показан пример фрейма-прототипа для ситуации "сдача экзамена в вузе".</p>
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="col-md-6 col-md-offset-3">
                                            <table class="table table-bordered table-hover">
                                                <caption class="text-uppercase text-center">Сдача экзамена в вузе</caption>
                                                <tbody>
                                                    <tr>
                                                        <td class="text-uppercase">Сдающий</td>
                                                        <td>(студент, аспирант, абитуриент, группа)</td>
                                                    </tr>
                                                    <tr>
                                                        <td class="text-uppercase">Принимающие</td>
                                                        <td>(лектор, ассистент, комиссия)</td>
                                                    </tr>
                                                    <tr>
                                                        <td class="text-uppercase">Предмет/Дисциплина</td>
                                                        <td>(название предмета/дисциплины)</td>
                                                    </tr>
                                                    <tr>
                                                        <td class="text-uppercase">Результат</td>
                                                        <td>(оценка, баллы)</td>
                                                    </tr>
                                                    <tr>
                                                        <td class="text-uppercase">Место/Время</td>
                                                        <td>(расписание сессии)</td>
                                                    </tr>
                                                </tbody>
                                            </table>
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="col-md-12">
                                            <p class="indent">Комментируя этот пример, можно указать на&nbsp;важнейшее свойство фреймов, связанное с&nbsp;тем, что удаление из&nbsp;этого описания любого <span class="text-primary" data-toggle="tooltip" data-placement="top" title="роль">актанта</span> приводит к&nbsp;потере свойств, определющих суть данного явления&nbsp;&mdash; сдача экзамена в&nbsp;вузе.</p>
                                            <p class="indent">Другая сильная сторона фреймов заключается в&nbsp;возможности включения в&nbsp;слоты фрейма различных предположений и&nbsp;ожиданий, что позволяет моделировать ситуации, в&nbsp;которых отсутствует упоминание о&nbsp;различных деталях (например, широкое использование <em>по&nbsp;умолчанию</em> некоторых стандартных для ситуации значений и&nbsp;т.&nbsp;п.)</p>
                                            <p class="indent">Фреймы легко организуются в&nbsp;<span class="text-primary" data-toggle="tooltip" data-placement="top" title="без учета имен слотов при отсылке к другим фреймам">однородные</span> и&nbsp;<span class="text-primary" data-toggle="tooltip" data-placement="top" title="c учетом имен слотов при отсылке к другим фреймам">неоднородные</span> сети фреймов, что позволяет многим специалистам в&nbsp;области&nbsp;<span class="text-primary" data-toggle="tooltip" data-placement="top" title="Искусственный интеллект">ИИ</span> считать фреймы частым видом специально организованных семантических сетей.</p>
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="col-md-12">
                                            <p class="pull-right text-muted"><em>Источник: Рыбина Г.В. Основы построения интеллектуальных систем. Учебное пособие. – М.: Финансы и статистика; ИНФРА‑М, 2010. – 432с.</em></p>
                                        </div>
                                    </div>',
    practical_part: '<h4 class="text-center">Введение</h4>
                                            <p class="indent">В&nbsp;данной лабораторной работе используется упрощенная структура фрейма вида:</p>
                                            <div class="row">
                                                <div class="col-md-10 col-md-offset-1">
                                                    <p class="no-margin"><code>(</code></p>
                                                    <p><code>FrameName</code></p>
                                                    <p class="indent-2 no-margin"><code>(SlotName1(SlotType1(Value11)(Value12)..(Value1M)))</code></p>
                                                    <p class="indent-2 no-margin"><code>(SlotName2(SlotType2(Value21)(Value22)..(Value2M)))</code></p>
                                                    <p class="indent-2 no-margin"><code>...</code></p>
                                                    <p class="indent-2 no-margin"><code>(SlotNameN(SlotTypeN(ValueN1)(ValueN2)..(ValueNM)))</code></p>
                                                    <p class="no-margin"><code>)</code></p>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="col-md-1">
                                            <p class="pull-right">где</p>
                                        </div>
                                        <div class="col-md-4">
                                                <ul>
                                                    <li><code>FrameName</code> &mdash; имя фрейма;</li>
                                                    <li><code>SlotName</code> &mdash; имя слота;</li>
                                                    <li><code>SlotType</code> &mdash; тип слота;</li>
                                                    <li><code>Value</code> &mdash; значение слота;</li>
                                                </ul>
                                        </div>
                                    </div>
                                     <!-- Сценарий лабораторной работы -->
                                    <div class="row">
                                        <div class="col-md-12">
                                            <h4 class="text-center">Сценарий лабораторной работы</h4>
                                            <p><strong>1.</strong> Вам необходимо зарегистрироваться.</p>
                                            <p class="indent">Для этого нажмите на&nbsp;кнопку <span class="label label-default">Регистрация</span>, и&nbsp;введите свою <strong>группу</strong>,<strong>фамилию</strong>,<strong>инициалы</strong> и&nbsp;<strong>пароль</strong> на&nbsp;латинице.</p>
                                            <p class="text-center"><img class="img-thumbnail img-responsive" src="/assets/reg.png"></p>
                                            <p class="indent">Нажмите кнопку <span class="label label-default">Зрегистрировать</span> и&nbsp;возвращайтесь в&nbsp;окно авторизации. Вводите свои данные, и&nbsp;нажимайте кнопку <span class="label label-default">Начать</span> для начала лабораторной работы.</p>
                                            <p class="text-center"><img class="img-thumbnail img-responsive" src="/assets/auth.png"></p>
                                            <p><strong>2.</strong> Преред вами главное окно работы, в&nbsp;котором три раздела: словарь, окно для ввода процедур, окно результата и&nbsp;описание задания</p>
                                            <p class="text-center"><img class="img-thumbnail img-responsive" src="/assets/inputwind.png"></p>
                                            <p class="indent">В&nbsp;зависимости от&nbsp;варианта вамбудет предоставлен готовый, заранее <strong>не&nbsp;правильный</strong> фрейм, который вам необходимо будет отредактировать, чтобы получить верный фрейм.</p>
                                            <p class="indent">Чтобы посмотреть структуру предоставленного фрейма вам нужно будет воспользоваться процедурой <code>&lt;frame? !Имя_фрейма&gt;</code>, где <code>Имя_фрейма</code> берется из&nbsp;словаря.</p>
                                            <p class="indent">Далее с&nbsp;помощью остальных процедур вы&nbsp;редактируете фрейм проблемной области, используя <strong>только слова из&nbsp;словаря</strong></p>
                                            <p class="indent">Для этого вам необходимо будет воспользоваться доступными для вас процедурами и&nbsp;сцеальными символами, <em>см. далее</em>.</p>
                                            <!-- Тут место под группу из двух таблиц -->
                                            <p class="indent">Процедуры пишутся в&nbsp;<span class="text-primary" data-toggle="tooltip" data-placement="top" title="центральное окно">окне запроса</span>. Для их&nbsp;выполнения необходимо нажать кнопку <span class="label label-default">Выполнить</span>.</p>
                                            <p class="indent">В&nbsp;правом окне вы&nbsp;увидите результат введенных процедур.</p>
                                            <p class="text-center"><img class="img-thumbnail img-responsive" src="/assets/windwork.png"></p>
                                            <p class="indent">Когда поймете, что работа завршена, вы&nbsp;отредактировали верно фрейм&nbsp;&mdash; нажмите кнопку <span class="label label-default">Завершить</span>.</p>
                                            <p class="indent lead font-lg bg-danger">В&nbsp;именах слотов, фреймов и&nbsp;значениях слотов <strong>не&nbsp;используйте</strong> пробелы, вместо этого используйте символ <strong><span class="text-primary" data-toggle="tooltip" data-placement="top" title="нижнее подчеркивание">&laquo;_&raquo;</span></strong></p>
                                            <h4 class="text-center">Будьте внимательны, и&nbsp;удачи!</h4>')






















########################################### 5 #########################################################

MethodicalMaterial.create(
    name: 'Компоненты ЛП',
    title: '<h1>Компоненты лингвистической прозы</h1>',
    description: '<h3 class="aling-center">Уважаемые студенты!</h3>
                            <p class="lead text-center">Здесь собраны методические указания для успешного выполнения <strong>компонента выявления умений строить компоненты лингвистической модели подъязыка деловой прозы</strong> в Научной лаборатории ИСиТ НИЯУ МИФИ.</p>',
    theoretical_part: '<div class="row">
                                        <div class="col-md-8 col-md-offset-2">
                                            <table class="table table-striped table-bordered">
                                                <caption class="text-center">Перечень НКФ-словоформ входного ЕЯ-текста</caption>
                                                <thead>
                                                    <tr>
                                                        <th>Часть речи</th>
                                                        <th>Нормальная каноническая форма (НКФ)</th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <tr>
                                                        <td>Существительное</td>
                                                        <td>Именительный падеж единственного числа</td>
                                                    </tr>
                                                    <tr>
                                                        <td>Местоимение</td>
                                                        <td>1-е лицо единственного и&nbsp;множественного числа</td>
                                                    </tr>
                                                    <tr>
                                                        <td>Глагол</td>
                                                        <td>Инфинитив</td>
                                                    </tr>
                                                    <tr>
                                                        <td>Причастие</td>
                                                        <td>Инфинитив исходного глагола</td>
                                                    </tr>
                                                    <tr>
                                                        <td>Деепричастие</td>
                                                        <td>Инфинитив исходного глагола</td>
                                                    </tr>
                                                    <tr>
                                                        <td>Прилагательное (полное и&nbsp;краткое)</td>
                                                        <td>Именительный падеж единственного числа мужского рода</td>
                                                    </tr>
                                                    <tr>
                                                        <td>Отглагольное существительное (имена действий)</td>
                                                        <td>Инфинитив исходного глагола</td>
                                                    </tr>
                                                    <tr>
                                                        <td>Отглагольное прилашательное (имена действий)</td>
                                                        <td>Инфинитив исходного глагола</td>
                                                    </tr>
                                                    <tr>
                                                        <td>Отадъективное существительное (имена свойств)</td>
                                                        <td>Именительный падеж единственного числа мужского рода исходного прилагательного</td>
                                                    </tr>
                                                    <tr>
                                                        <td>Качественное наречие</td>
                                                        <td>Именительный падеж единственного числа мужского рода исходного прилагательного</td>
                                                    </tr>
                                                    <tr>
                                                        <td>Порядковое числительное</td>
                                                        <td>Именительный падеж единственного числа мужского рода исходного числительного</td>
                                                    </tr>
                                                    <tr>
                                                        <td>Качественное числительное</td>
                                                        <td>Именительный падеж</td>
                                                    </tr>
                                                </tbody>
                                            </table>
                                            <table class="table table-striped table-bordered">
                                                <caption class="text-center">Перечень упрощенных семантико-синтаксических связей</caption>
                                                <thead>
                                                    <tr>
                                                        <th>Тип связи</th>
                                                        <th>Компоненты предложения, между которыми осуществляется данная связь</th>
                                                        <th>Разновидность связи и&nbsp;ее&nbsp;обозначение</th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <tr>
                                                        <td>Глубинный падеж (семантическая валентность)</td>
                                                        <td>Предикаты -&gt; аргументы</td>
                                                        <td>
                                                        <code>A</code> &mdash;&nbsp;быть &laquo;агентом&raquo; действия<br>
                                                        <code>O</code> &mdash;&nbsp;быть &laquo;объектом&raquo; действия<br>
                                                        <code>D</code> &mdash;&nbsp;быть &laquo;адресатом&raquo; действия<br>
                                                        <code>T</code> &mdash;&nbsp;быть &laquo;темой&raquo; действия<br>
                                                        <code>I</code> &mdash;&nbsp;быть &laquo;инструментом&raquo; действия<br>
                                                        <code>L</code> &mdash;&nbsp;быть &laquo;местом&raquo; действия<br>
                                                        <code>S</code> &mdash;&nbsp;быть &laquo;начальной точкой&raquo; действия<br>
                                                        <code>F</code> &mdash;&nbsp;быть &laquo;конечной точкой&raquo; действия<br>
                                                        <code>G</code> &mdash;&nbsp;быть &laquo;целью&raquo; действия<br>
                                                        <code>C</code> &mdash;&nbsp;быть &laquo;условием&raquo; действия<br>
                                                        <code>W</code> &mdash;&nbsp;быть &laquo;временем&raquo; действия<br>
                                                        <code>M</code> &mdash;&nbsp;быть &laquo;способом&raquo; действия<br>
                                                        <code>B</code> &mdash;&nbsp;быть &laquo;сроком&raquo; действия<br>
                                                        <code>X</code> &mdash;&nbsp;быть &laquo;количеством&raquo; действия<br>
                                                        <code>R</code> &mdash;&nbsp;быть &laquo;результатом&raquo; действия<br>
                                                        <code>K</code> &mdash;&nbsp;быть &laquo;контрагентом&raquo; действия<br>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>Необязательная валентность (характеристика предиката)</td>
                                                        <td>Предикат -&gt; распространители</td>
                                                        <td>Грамматические связи типа:<br>
                                                        &laquo;обстоятельство места&raquo; <code>(L)</code> <br>
                                                        &laquo;обстоятельство времени&raquo; <code>(W)</code> <br>
                                                        &laquo;обстоятельство цели&raquo; <code>(G)</code> <br>
                                                        &laquo;обстоятельство причины&raquo; <code>(C)</code> <br>
                                                        &laquo;обстоятельство образа действия&raquo; <code>(M)</code> <br>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td rowspan="7">Атрибутивная связь (характеризация понятия и&nbsp;характеризация свойства)</td>
                                                        <td>
                                                        Существительное -&gt; прилашательное
                                                        </td>
                                                        <td>
                                                        Определимая связь <code>(H)</code>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                        Количественное числительное -&gt; существительное и&nbsp;др.
                                                        </td>
                                                        <td>
                                                        Количественная связь <code>(H)</code>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                        Существительное -&gt; существительное
                                                        </td>
                                                        <td>
                                                        Притяжательная связь <code>(H)</code>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                        Отадъективное существительное -&gt; существительное
                                                        </td>
                                                        <td>
                                                        Притяжательная связь <code>(H)</code>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                        Существительное -&gt; предлог -&gt; существительное
                                                        </td>
                                                        <td>
                                                        Притяжательная связь <code>(H)</code>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                        Существительное -&gt; нарицательное существительное
                                                        </td>
                                                        <td>
                                                        Именная связь <code>(H)</code>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                        Наречие -&gt; прилагательное и&nbsp;др.
                                                        </td>
                                                        <td>
                                                        Модификационная связь <code>(M)</code>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>Генетивная связь &laquo;часть-целое&raquo;</td>
                                                        <td>Существительное -&gt; существительное</td>
                                                        <td><code>P</code></td>
                                                    </tr>
                                                    <tr>
                                                        <td>Связь типа &laquo;быть подмножеством&raquo;</td>
                                                        <td>Существительное -&gt; существительное</td>
                                                        <td><code>U</code></td>
                                                    </tr>
                                                    <tr>
                                                        <td>Связь типа &laquo;быть элементом&raquo;</td>
                                                        <td>Существительное -&gt; существительное</td>
                                                        <td><code>E</code></td>
                                                    </tr>
                                                </tbody>
                                            </table>
                                        </div>
                                        <div class="col-md-12">
                                            <p class="pull-right text-muted"><em>Источник: Рыбина Г.В. Основы построения интеллектуальных систем. Учебное пособие. – М.: Финансы и статистика; ИНФРА‑М, 2010. – 432с.</em></p>
                                        </div></div>',
    practical_part: '<div class="row">
                                        <div class="col-md-12">
                                            <h4 class="text-center">Введение</h4>
                                            <p class="indent">Лабораторная работа состоит из трех компонентов - <span class="text-primary" data-toggle="tooltip" data-placement="top" title="синтаксический">G</span> , <span class="text-primary" data-toggle="tooltip" data-placement="top" title="лексический">V</span>, <span class="text-primary" data-toggle="tooltip" data-placement="top" title="семантический">S</span>. Компоненты выполняются в представленном ранее порядке. Каждый из компонентов оценивается отдельно, после чего вычисляется итоговая оценка, хочется отметить, что выполнение каждого из компонентов займет у вас не малое количество времени.</p>
                                            <p class="indent lead font-lg bg-danger">Обращаем ваше внимание на то, что данная лабораторная работа ограничена по времени 2 часами.</p>
                                            <p class="indent">После успешной авторизации по логинам и паролям предоставленными инженерами лаборатории перед вами откроется окно навигации.</p>
                                            <p class="text-center"><img class="img-thumbnail img-responsive" src="/assets/ling.png"></p>
                                            <p class="indent">Далее нажимая на ссылку <span class="label label-default">Лингвистика</span> перед вами откроется окно выбора варианта.</p>
                                            <p class="text-center"><img class="img-thumbnail img-responsive" src="/assets/var_ling.png"></p>
                                            <p class="indent lead font-lg bg-danger">Указывайте вариант выданный сотрудниками лаборатории, в случае неудачной попыпки сдачи одного из компонентов результаты сохраняются в базе и в следующий раз вы сможете пересдать какой-либо компонент только под вашим вариантом.</p>
                                            <p class="indent">После выбора своего варианта нажимайте на кнопку <span class="label label-default">Начать работу</span></p>
                                            <h4 class="text-center">Сценарий лабораторной работы</h4>
                                            <p class="indent">Перед вами откроется окно с заданием компонента <span class="text-primary" data-toggle="tooltip" data-placement="top" title="синтаксический">G</span>. Ознакомьтесь с интерфейсом. В правом верхнем углу находится краткая справка.</p>
                                            <p class="text-center"><img class="img-thumbnail img-responsive" src="/assets/sup2_comp_G.png"></p>
                                            <p class="indent">После того как вы ознакомитесь с интерфейсом и заданием приступайте к выполнению. Необходимо произвести анализ предложений и обозначить в них основные и именные группы если такие имеются.</p>
                                            <p class="indent">На панели справа располагается список основных и именных групп. После выделения группы слов необходимо присвоить им соответствущую группу. Для добавления новой именной группы нужно нажать на кнопку <span class="label label-default">Добавить ИГ</span>, после новую именную группу можно связать с группой слов <strong>в предложения</strong>.</p>
                                            <p class="indent lead font-lg bg-danger">Будьте внимательны, не создавайте лишних именных групп. Одну именную группу можно использовать в разных предложениях одновременно.</p>
                                            <p class="text-center"><img class="img-thumbnail img-responsive" src="/assets/sup_comp_G.png"></p>
                                            <p class="indent">В ходе выполнения работы у вас должны быть задействованы все слова в предложении. Лучше начинать с <strong>основных групп</strong> после чего создавать новые именные группы.</p>
                                            <p class="text-center"><img class="img-thumbnail img-responsive" src="/assets/ques_comp_G.png"></p>
                                            <p class="indent">Если в ходе работы вы поняли, что совершили ошибку, то возможно отменить присвоенную вами именную группу. Для этого нужно выделить ошибочную именную группу и нажать на крестик.</p>
                                            <p class="text-center"><img class="img-thumbnail img-responsive" src="/assets/del_comp_G.png"></p>
                                            <p class="indent">После того как все слова в каждом из предложений будут задействованы у вас получится такая картинка. Можете переходить ко второй части выполнения компонента <code>G</code>.</p>
                                            <p class="text-center"><img class="img-thumbnail img-responsive" src="/assets/done_comp_G.png"></p>
                                            <p class="indent">Вам необходимо описать модель компонента G в БНФ.</p>
                                            <p class="indent lead font-lg bg-danger">Будьте внимательны, порядок описания <strong>не важен</strong>.</p>
                                            <p class="text-center"><img class="img-thumbnail img-responsive" src="/assets/2_comp_G.png"></p>
                                            <p class="indent">Покажем на примере описания предложения типа вопрос. В данном примере наше предложение состоит из именной группы 1, предиката, именной группы 2 и именной группы 3.</p>
                                            <p class="text-center"><img class="img-thumbnail img-responsive" src="/assets/2_doing_comp_G.png"></p>
                                            <p class="indent lead font-lg bg-danger">Необходимо описать все возможные варианты каждого из типов предложений пока будет сохранятся смысл и выполнятся правила русского языка.</p>
                                            <p class="indent">Для того чтобы сделать это необходимо перетаскивать <strong>первый элемент</strong> нового варианта на кнопку <span class="label label-default">+ Вариант</span>. Таким образом, новый вариант будет разделен с предыдущим вертикальной чертой <code>|</code>.</p>
                                            <p class="text-center"><img class="img-thumbnail img-responsive" src="/assets/2_doing_comp_G-2.png"></p>
                                            <p class="indent">Следующим шагом будет описание именных групп, приведем пример.</p>
                                            <p class="text-center"><img class="img-thumbnail img-responsive" src="/assets/2_doing_comp_G-3.png"></p>
                                            <p class="indent lead font-lg bg-danger">Обратите внимание! У вас не должно быть именных групп с разным название и одинаковым описанием.</p>
                                            <p class="indent">Нажимем кнопку <span class="label label-default">Отправить</span> и переходим к выполнению к следующему компоненту <span class="text-primary" data-toggle="tooltip" data-placement="top" title="лексический">V</span>.</p>
                                            <p class="indent">Вам необходмо описать словари, используемые для хранения словоформ текса подъязыка деловой прозы.</p>
                                            <p class="indent lead font-lg bg-danger">Порядок описания также не важен.</p>
                                            <p class="text-center"><img class="img-thumbnail img-responsive" src="/assets/comp_V.png"></p>
                                            <p class="indent">После описания всех словарей переходите к компоненту <span class="text-primary" data-toggle="tooltip" data-placement="top" title="семантический">S</span>. Для этого нужно нажать кнопку <span class="label label-default">Готово</span>.</p>
                                            <p class="indent">Для выполнения компонента <span class="text-primary" data-toggle="tooltip" data-placement="top" title="семантический">S</span> необходимо знать теоретическую часть и иметь представление о языке CAREL.</p>
                                            <p class="text-center"><img class="img-thumbnail img-responsive" src="/assets/comp_S.png"></p>
                                            <p class="indent">Вам необходимо перетащить нужные по вашему мнению слова на валентные места и верно указать их модальность. Покажем на примере предиката из первого предложения.</p>
                                            <p class="text-center"><img class="img-thumbnail img-responsive" src="/assets/doing_comp_S.png"></p>
                                            <p class="indent lead font-lg bg-danger">Обратите внимание на форму слова находящуюся на валентном месте. А также на уровень, на котором находятся вабранное слово.</p>
                                            <p class="indent">Регулировать уровень можно с помощью стрелок <code>&lt;</code> и <code>&gt;</code>.</p>
                                            <p class="indent">После завершения компонента <span class="text-primary" data-toggle="tooltip" data-placement="top" title="семантический">S</span> нужно нажать на кнопку <span class="label label-default">Отправить</span>. Система покажет ваши результаты и выведет ошибки, если таковые имеются, а также автоматических подсчитает итоговую оценку.</p>
                                            <h4 class="text-center">Будьте внимательны, и&nbsp;удачи!</h4>
                                        </div>
                                    </div>')



















########################################### 6 #########################################################

MethodicalMaterial.create(
    name: 'УТЗ',
    title: '<h1>Учебно-тренировочные задания</h1>',
    description: '<h3 class="aling-center">Уважаемые студенты!</h3>
                            <p class="lead text-center">Здесь собраны методические указания для успешного выполнения лабораторных заданий по теме <strong>УТЗ</strong> в Научной лаборатории ИСиТ НИЯУ МИФИ.</p>',
    theoretical_part: '<p class="pull-right text-muted"><em>Источник: Рыбина Г.В. Основы построения интеллектуальных систем. Учебное пособие. – М.: Финансы и статистика; ИНФРА‑М, 2010. – 432с.</em></p>',
    practical_part: '<h4 class="text-center">Введение</h4>
                                            
                                            <h4 class="text-center">Будьте внимательны, и&nbsp;удачи!</h4>')















########################################### 7 #########################################################

MethodicalMaterial.create(
    name: 'Психотесты',
    title: '<h1>Психотесты</h1>',
    description: '<h3 class="aling-center">Уважаемые студенты!</h3>
                            <p class="lead text-center">Здесь собраны методические указания для успешного выполнения лабораторных заданий по теме <strong>УТЗ</strong> в Научной лаборатории ИСиТ НИЯУ МИФИ.</p>',
    theoretical_part: '<h5 class="text-center">Опросник Б.&nbsp;Н. Смирнова</h5>
                                            <p class="indent">Опросник Б.&nbsp;Н. Смирнова позволяет выявить рад полярных свойств темперамента: экстраверсию&nbsp;&mdash; интроверсию, эмоциональную возбудимость&nbsp;&mdash; эмоциональную уравновешенность, темп реакций (быстрый&nbsp;&mdash; медленный), активность (высокую&nbsp;&mdash; низкую). Он&nbsp;также имеет шкалу искренности испытуемого при ответах на&nbsp;вопросы, позволяющую оценить надежность полученных результатов.</p>
                                            <h5 class="text-center">Опросник Стефансона</h5>
                                            <p class="indent">Данная методика используется для изучения представлений о&nbsp;себе. Разработана В. Стефансоном и&nbsp;опубликован в&nbsp;1958&nbsp;г. Достоинством методики является&nbsp;то, что при работе с&nbsp;ней испытуемый проявляет свою индивидуальность, реальное &laquo;я&raquo;, а&nbsp;не&nbsp;&laquo;соответствие&nbsp;&mdash; несоответствие&raquo; статистическим нормам и&nbsp;результатам других людей. Возможна и&nbsp;повторная сортировка того&nbsp;же набора карточек, но&nbsp;в&nbsp;других отношениях:
                                            <ul>
                                                <li>социальное &laquo;я&raquo; (каким меня видят другие?);</li>
                                                <li>идеальное &laquo;я&raquo; (каким&nbsp;бы я&nbsp;хотел быть?);</li>
                                                <li>актуальное &laquo;я&raquo; (какой я&nbsp;в&nbsp;разных ситуациях?);</li>
                                                <li>значимые другие (каким я&nbsp;вижу своего партнера?);</li>
                                                <li>идеальный партнер (каким&nbsp;бы я&nbsp;хотел видеть своего партнера?).</li>
                                            </ul></p>
                                            <p class="indent">Методика позволяет определить шесть основных тенденций поведения человека в&nbsp;реальной группе: зависимость, независимость, общительность, необщительность, принятие борьбы и&nbsp;избегание борьбы. Тенденция к&nbsp;зависимости определена как внутреннее стремление индивида к&nbsp;принятию групповых стандартов и&nbsp;ценностей: социальных и&nbsp;морально-этических. Тенденция к&nbsp;общительности свидетельствует о&nbsp;контактности, стремлении образовать эмоциональные связи как в&nbsp;своей группе, так и&nbsp;за&nbsp;ее&nbsp;пределами. Тенденция к&nbsp;борьбе&nbsp;&mdash; активное стремление личности участвовать в&nbsp;групповой жизни, добиваться более высокого статуса в&nbsp;системе межличностных взаимоотношений; в&nbsp;противоположность этой тенденции&nbsp;&mdash; избегание борьбы&nbsp;&mdash; показывает стремление уйти от&nbsp;взаимодействия, сохранить нейтралитет в&nbsp;групповых спорах и&nbsp;конфликтах, склонность к&nbsp;компромиссным решениям. Каждая из&nbsp;этих тенденций имеет внутреннюю и&nbsp;внешнюю характеристики, т.&nbsp;е. зависимость, общительность и&nbsp;борьба могут быть истинными, внутренне присущими личности, а&nbsp;могут быть внешними, своеобразной маской, скрывающей истинное лицо человека. Если число положительных ответов в&nbsp;каждой сопряженной паре (зависимость&nbsp;&mdash; независимость, общительность&nbsp;&mdash; необщительность, принятие борьбы&nbsp;&mdash; избегание борьбы) приближается к&nbsp;20, то&nbsp;мы&nbsp;говорим об&nbsp;истинном преобладании той или иной устойчивой тенденции, присущей индивиду и&nbsp;проявляющейся не&nbsp;только в&nbsp;определенной группе, но&nbsp;и&nbsp;за&nbsp;ее&nbsp;пределами.</p>
                                            <p class="pull-right text-muted"><em>Источник: Открытый электронный ресурс ru.wikipedia.org.</em></p>',
    practical_part: '<h4 class="text-center">Введение</h4>
                                            <p class="indent">После авторизации вам нужно выбрать вариант Психологические тесты.</p>
                                            <p class="text-center"><img class="img-thumbnail img-responsive" src="/assets/ling.png"></p>
                                            <p class="indent">Перед вами откроется окно с компонентом выявления личностных характеристик обучаемого.</p>
                                            <p class="text-center"><img class="img-thumbnail img-responsive" src="/assets/psycho.png"></p>
                                            <p class="indent"> Компонент интуитивно понятен. Вы выбираете интересующий вас тест и начинаете его проходить.</p>
                                            <p class="text-center"><img class="img-thumbnail img-responsive" src="/assets/panel_var_psycho.png"></p>
                                            <p class="indent lead font-lg bg-danger">Каждый тест содержит различное количество вопросов.</p>
                                            <p class="text-center"><img class="img-thumbnail img-responsive" src="/assets/doing_var_psycho.png"></p>
                                            <p class="indent">Для того чтобы завершить тестирование нужно нажать кнопку <span class="label label-primary">Завершить</span> на панели психологические тесты.</p>
                                            <p class="text-center"><img class="img-thumbnail img-responsive" src="/assets/done_test_psycho.png"></p>
                                            <p class="indent lead font-lg bg-danger">Если в тесте есть хотя бы один вопрос без ответа, то система не разрешит вам его завершить. Должны быть даны ответы на все вопросы.</p>
                                            <h4 class="text-center">Будьте внимательны, и&nbsp;удачи!</h4>')

User.create(login: 'root', pass: Digest::MD5.hexdigest('root123qwerty'), role: 'admin')
