#!/usr/bin/env bash
echo -e "Скрипт выполняет ansible-vault шифрование/дешифрование файлов в указанном каталоге"
echo -e "На вход скрипт принимает три аргумента"
echo -e "1 - путь к каталогу для шифровки/дешифровки"
echo -e "2 - encrypt или decrypt для шифрования и дешифрования соответственно"
echo -e "3 - путь к vault-password-file, если не указано, будет спрашивать пароль для шифрования/дешифрования каждого файла"

VAULT_FILE_PATH=$3

if [ -v $1 ] || [ -v $2 ]
	then
		echo "Нет обязательных параметров"
fi

if [ "$2" == "encrypt" ]
	then
		if [ -v $VAULT_FILE_PATH ]
			then
				cd $1
					for f in *
						do
							ansible-vault $2 $f
						done
			else
				cd $1
					for f in *
						do
							ansible-vault $2 $f --vault-password-file=$VAULT_FILE_PATH
						done
		fi
fi

if [ "$2" == "decrypt" ]
	then
		if [ -v $VAULT_FILE_PATH ]
			then
				cp -r $1 $1-decrypt
				cd $1-decrypt
					for f in *
						do
							ansible-vault $2 $f
						done
			else
				cp -r $1 $1-decrypt
				cd $1-decrypt
					for f in *
						do
							ansible-vault $2 $f --vault-password-file=$VAULT_FILE_PATH
						done
		fi
fi
