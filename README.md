# EASYTODO
Aplication for keeping your mind free
## RUN TESTS

xcodebuild test -scheme TODO -destination 'platform=iOS Simulator,name=iPhone 16'

## WHAT WAS DONE

### WORK PACKAGE 1
[Základná štruktúra a užívateľské rozhranie] - [x]
-	Description: Vytvorenie základnej štruktúry aplikácie a implementácia hlavného užívateľského rozhrania pomocou SwiftUI.
-	Expected Outcome: Funkčné užívateľské rozhranie s hlavným zoznamom úloh a možnosťou pridávania nových úloh
-	Expected Time Consumption: 10 hodin

### WORK PACKAGE 2
[ Implementácia SwiftData, CRUD operácií a iCloud zálohy] - [x]
-	Description: [Integrácia SwiftData pre správu dát, implementácia CRUD (Create, Read, Update, Delete) operácií pre úlohy a pridanie podpory pre iCloud zálohu.] 
-	Expected Outcome: [Plne funkčné ukladanie, načítavanie, aktualizácia a mazanie úloh s perzistenciou dát lokálne a v iCloude.]
-	Expected Time Consumption: 20 hodin 

### WORK PACKAGE 3
[ Pokročilé funkcie a kategorizácia] - [x]
-	Description: [ Implementácia pokročilých funkcií ako prioritizácia úloh, nastavenie termínov a kategorizácia úloh do projektov.] 
-	Expected Outcome: [Možnosť nastaviť priority, termíny a kategórie pre úlohy, s príslušným filtrovaním a zobrazovaním.]
-	Expected Time Consumption: 20 hodin
### WORK PACKAGE 4
[Notifikácie a widgety] - [x]
-	Description: [Pridanie systému notifikácií pre termíny úloh a vytvorenie widgetov pre rýchly prehľad úloh na domovskej obrazovke.] 
-	Expected Outcome: [Funkčné notifikácie pre nadchádzajúce úlohy a widgety zobrazujúce aktuálne úlohy.]
-	Expected Time Consumption: 15 hodin

### ADDITIONAL FEATURES

Settings contents: ColorSchemes

Milestones I have achieved:
- implementation of UI with the main list of tasks
- categorization with drag and drop (user can take the task and drag it to the top, depends on his priorities)
- Implemented SwiftData and CRUD operations, so the user can add, update (as done), remove and read the tasks
- Added deadlines, which triggers notifications, so if user forget on something that has to be done by today (for example), so it triggers notification with the exact name of the task he forgot
- widget shows last 3 tasks, so the user dosnt have to open app to revive his tasks in mind
- notifications are set to remind that task is outdated (the deadline date is gone), and one notification is triggered if there are still tasks TODO
- added settings where user can either set background color of task list and also implemented app color settings (light mode, dark mode and system mode which is picked by system settings in your phone)
- iCloud implementation was very hard to do for amateour swift developer
