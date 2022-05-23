![banner](https://cdn.discordapp.com/attachments/944581422876885055/978352203729338398/unknown.png)

# INTRODUCTION
Everyday people experience different kinds of obstacles, incidents and problems which require external help from the authorities. In order to access / get help, one must get in contact with the authorities and the units on the field. Conventional emergency related communications have certain types of shortcomings and problems of their own. Especially time required for this process can be vital for some situations that may result in great harm.
 
The **motivation** of this project was helping the emergency assistance seekers via getting them help they seek, to the operators and units by utilizing the Internet instead of telephony lines. Seeking help with telephone calls in those critical situations can be expensive in terms of time (i.e. specifying the location, describing the situation, waiting to be connected with the operator). With assistance from the Internet and **location** functionality of the smartphones, a remedy to those problems can be plausible. Any reduction in response times to the critical situations can be beneficial both in **time, money and well-being of the society**. Its main aim is to reduce the response time in the immediate emergency workflow as much as possible and ease the process for requesters.

The application bundle became a platform for both **individuals who are seeking assistance** against urgent situations and **operators** who will monitor incoming assistance requests and notify appropriate **units** to dispatch. We believe it can be used to submit immediate emergency requests and request help pretty quickly compared to conventional communication used for seeking procedures. 

Our approach to the problem is creating an application bundle which involves mobile application, web application and a web API to be consumed by these applications. We used the latest technology and frameworks to actualize our project. We successfully developed a good mobile application using **Flutter** for both units and seekers to submit / respond to emergency requests, a **RESTful** web API using **Django** and **DRF** to provide a backend for both web application and mobile application, a web application using **React.js** for operators that are people manage the requests and their relations.

# RESULTS
Firstly, we designed a login page with authentication. If the user enters the correct email and password, the backend side would control this information and create a one token for this user. The user info is kept into local storage. The user with a token, can access all relevant pages. Only operators can use this part of the frontend. First page after the login, is the dashboard page. 

![dashboard](https://cdn.discordapp.com/attachments/944581422876885055/978371455349841970/unknown.png)

This page includes a menu and some statistics like total cases, closed cases and charts etc. Also, we provided a good design for the visuality and user experience for this page. An operator can look at new cases, active cases and closed cases at the left menu from the dashboard page, also they can access the staff management page there. In the staff management page, there is some information about the units such as name, number. To perform the user registration process, the operator can select the ones from the unit and approve the units who want to register the systems as police, health personnel and firefighters. Then another part of our website is the case table. 

![casetable](https://cdn.discordapp.com/attachments/944581422876885055/978371545661583380/unknown.png)

New and active cases have shown in the same table but closed cases in different tables. The action state is visible in the ‘action_taken’ column. The users can see the case detail page by clicking on the right button. In the case detail page, there are two cards in here and they show victim and unit request information. If there is a new case, the operator would look at the current location and voice recording comes from the victim. For this purpose, the operator can easily select and unselect the units close to the case location. 

![map](https://cdn.discordapp.com/attachments/944581422876885055/978371983681146942/unknown.png)

After all that, the operator would click on the send units button and the data will be sent to the backend side. In addition, the operator can back the home page when they want by clicking on the home icon on the appbar.

We made some changes on our Mobile Application compared to our design proposed in the beginning. In the proposal there were three views for normal users. Nearly all functionality and use cases except push notifications for attention seekers are implemented and tested manually whether works in an orchestrated way with the web API. There are some location information related problems due to usage of Android emulator that isn’t about our implementation. Location services of the Android emulator do not work when microphone integration is enabled for the Android Studio emulator which is developed by Google and JetBrains; but we neither tested it with a real environment. Users can successfully send emergency requests with location, message and voice recording, display thyselves account information and change them accordingly. Units can display the emergency requests assigned to them, close them if an incident is solved, play the voice recordings and display the information including location about the incident. We dropped push notifications due to time related issues.

![ss](https://cdn.discordapp.com/attachments/944581422876885055/978380748627247164/unknown.png)
![ss2](https://cdn.discordapp.com/attachments/944581422876885055/978384146441318400/unknown.png)

# ABOUT US

 - Backend Development:
    > Sencer Kaya [✉](mailto:sencerkaya@protonmail.com)
 - Frontend Development:
    > Mert Emre Öztürk [✉](mailto:meertemree@outlook.com)
 - Mobile Development:
	> Sadık Can Acar [✉](mailto:canacar26@gmail.com)
    

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