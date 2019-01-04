## Instruction


Install:

```
$ git clone https://github.com/soko1/mutt ~/.mutt
```

Example "accounts/account2/account3/account4/etc.." file:

```
set imap_user = "_PASTE_EMAIL_"
set imap_pass = "_PASTE_PASSWORD_"
set smtp_url = "smtp://_PASTE_LOGIN_@smtp.gmail.com:587/"
set smtp_pass = "_PASTE_PASSWORD_"
set from = "_PASTE_EMAIL_"
set realname = "_PASTE_FIRST_AND_LAST_NAME_"
```

Run:

```
$ gpg -c accounts # or gpg -e
$ shred -u accounts
$ mkdir -p ~/.muttrc/cache/bodies
$ touch ~/.emacs-mail
```

Press F1, F2, F3 for change mail account.
