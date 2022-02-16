
# emhelp : Backend Installation

### Notes :
- If project is going to be deployed into production, make sure that `DEBUG = True` is set instead of `DEBUG = False` in the `settings.py` which is under the mtaccess folder.
- This steps assumes that deployment takes place on Ubuntu Server.

#### Update and upgrade packages:
```
$ sudo apt update && sudo apt upgrade
```
#### Install Python 3 and pip:
```
$ sudo apt-get install python3-pip python3
```

#### Setup a Python environment, update pip and install requirements :
```
$ cd Backend
$ python3 -m venv env
$ source env/bin/activate
(env) $ python -m pip install --upgrade pip
(env) $ pip install -r requirements.txt
```
#### Make migrations and create a superuser :
```
(env) $ python manage.py makemigrations
(env) $ python manage.py migrate
(env) $ python manage.py createsuperuser
```

#### Collect all of the static content and run server:
```
(env) $ python manage.py collectstatic
(env) $ gunicorn --bind=0.0.0.0:8000 emhelp.wsgi
```