# yunohost-backup

It is my personal bash script for creating backups of most used apps on my Yunohost server.

## Installation

```bash
https://github.com/cichy1173/yh-backup.git
chmod u+x yh-backup/main.sh
```
## Usage
Firstly, is important to declare all info such as `SSD`, `DISC`, `BACKUP_DIRECTORY`. You should also edit `FAIL_STRING` and change `/dev/sda1` for the drive, that you use to backup data (the same as `DISC` value).

You should declare apps that You want to backup in `yunohost backup create --apps <your apps> ...` command.

You can change `find` command to change how old files should be deleted. 

If you want to automate backups with this script, you should declare that in `crontab`. For example, I want to create backups every tuesday, Thursday and Saturday. 
```bash
0 3 * * 2,4,6 bash <script_path>/yh-backup/main.sh
```
