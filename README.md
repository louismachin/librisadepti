# librisadepti

## Service

```
sudo ln -s /opt/librisadepti/librisadepti.service /etc/systemd/system/librisadepti.service
sudo systemctl daemon-reload
sudo systemctl enable librisadepti.service
sudo systemctl start librisadepti.service


sudo journalctl -u librisadepti.service -n 50
sudo journalctl -u librisadepti.service -f
```
