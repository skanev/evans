# language: bg
Функционалност: Новини
  За да може студентите да знаят какво се случва в курса
  като преподавателски екип
  искаме да можем да публикуваме новини на сайта

  Сценарий: Отговаряне на анкета
    Дадено че съм студент
    И че съществува анкета:
      """
      - name: main_language
        type: single-line
        text: Кой е основния ви език за програмиране?
      - name: editor
        type: multi-line
        text: Какъв текстов редактор ползвате?
      - name: best_language
        type: single-choice
        text: Кой от следните езици знаете най-добре?
        options:
          - Ruby
          - JavaScript
          - Python
          - Perl
      - name: known_languages
        type: multi-choice
        text: Кои от следните езици знаете?
        options:
          - Ruby
          - JavaScript
          - Python
          - Perl
      """
    Когато попълня анкетата с:
      | Въпрос                                  | Тип     | Отговор    |
      | Кой е основния ви език за програмиране? | Текст   | Ruby       |
      | Какъв текстов редактор ползвате?        | Текст   | Vim        |
      | Кои от следните езици знаете най-добре? | Избор   | Perl       |
      | Кои от следните езици знаете?           | Отметки | Ruby, Perl |
    То моите отговори трябва да бъдат:
      """
      main_language: Ruby
      editor: Vim
      best_language: Perl
      known_languages:
        - Ruby
        - Perl
      """

  Сценарий: Редактиране на отговор на анкета
    Дадено че съм студент
    И че съществува анкета:
      """
      - name: main_language
        type: single-line
        text: Кой е основния ви език за програмиране?
      - name: editor
        type: multi-line
        text: Какъв текстов редактор ползвате?
      """
    И че съм отговорил на анкетата с:
      """
      main_language: Ruby
      editor: Vim
      """
    Когато попълня анкетата с:
      | Въпрос                           | Тип   | Отговор |
      | Какъв текстов редактор ползвате? | Текст | Emacs   |
    То моите отговори трябва да бъдат:
      """
      main_language: Ruby
      editor: Emacs
      """
