# MentE

MentE is an app built for educational organizations with mentorship programs. Mentees sign up for the app, choose from a list of pre-approved mentors, and get matched with one by our proprietary algorithm. Mentors sign up for the app to give back without busy work and red tape. The app tracks the meetings between pairings, allowing administrators to quickly notice high-quality mentors for repeat involvement and trim low-quality mentors.

## Table of Contents
1. Getting Started
   - Requirements
   - Installation
   - Database Setup and Seeding
2. Running the Project
3. Tech Stack
4. Potential Features
5. Credits
6. License

## Getting Started
### Requirements
Be sure you've installed:
1. Ruby 3.4.1
2. Rails 7.2.2.1
3. PostgreSQL 14.15
4. Bundler 2.5.14
5. (Optional) If you're running this on a Windows machine, you should set up WSL2. [Here's a guide](https://gorails.com/setup/windows/10) on getting it running.

### Installation
1. First, clone the repo to your machine:
```bash
git clone https://github.com/DPI-Group-Project/MentorshipPlatform.git
```

2. Next, navigate to the repo in your terminal, then install the required ruby gems with the bundle command:
```bash
bundle
```
#### Database Setup and Seeding
3. Ensure you have an active PostgreSQL connection, then create your database and migrate the database from Rails:
```bash
rails db:create db:migrate
```

4. Run the sample data task to populate your new local database:
```bash
rails sample_data
```

#### Running the Project
5. Start the Rails server.
```bash
rails s
```

6. Visit `http://localhost:3000` to view the application in your browser of choice.

## Tech Stack
This is a Ruby on Rails project with a PostgreSQL backend. The MentE team chose this stack because we all learned it in [Discovery Partners Institute's Software Development Apprenticeship](https://dpi.uillinois.edu/apprenticeship/). Each contributor has also built at least one solo project with this tech stack, so we felt very comfortable with it.

## Potential Features
- In the future, with tools like [Hotwire Native](https://native.hotwired.dev/), it should be possible to take our hard work and port it to a mobile app.
- Check back for more use cases

## Credits
This app has been a labor of love from 10 dedicated software developers, project managers, designers and more. These contributors are listed in no particular order. Learn more about our team here:
- [Aizat Ibraimova](https://github.com/aizatibraimova) ([LinkedIn](https://www.linkedin.com/in/aizatibraimova/)) — Project Manager
- [Natalie Demyanenko](https://github.com/SaraDawner2000) ([LinkedIn](https://www.linkedin.com/in/natalie-demyanenko/)) — Scrum Manager, DevOps, Back-End Developer
- [Young Song](https://github.com/YoungSong99) ([LinkedIn](https://www.linkedin.com/in/youngsong-us/)) — UI/UX Designer, Front-End Developer, Back-End Developer
- [Jennifer Rahman](https://github.com/jb520) ([LinkedIn](https://www.linkedin.com/in/rahman-jennifer/)) — UI/UX Designer, Front-End Developer
- [Arpan Patel](https://github.com/APatel-AI) ([LinkedIn](https://www.linkedin.com/in/arpan-p/)) — UI/UX Designer, Front-End Developer, Back-End Developer
- [Brandon Varner](https://github.com/brvarner) ([LinkedIn](https://www.linkedin.com/in/brandonvarneral/)) — Front-End Developer, Back-End Developer, Team Lead
- [Maya Sheriff](https://github.com/MayaS1111) ([LinkedIn](https://www.linkedin.com/in/maya-marie-sheriff/)) — Back-End Developer, Team Lead
- [Benny Joram](https://github.com/borvux) ([LinkedIn](https://www.linkedin.com/in/benny-joram/)) — Back-End Developer
- [Reza Husain](https://github.com/rezahusain) ([LinkedIn](https://www.linkedin.com/in/reza-h-247a8820b/)) — Back-End Developer
- [Fadi Baker](https://github.com/FadiBaker92) ([LinkedIn](https://www.linkedin.com/in/fadi-baker/)) — Sales

## License
Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, subject to the following conditions:

1. The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

2. Any commercial use of derivative works based on this Software requires prior written approval from the the MentE team (those credited above).
