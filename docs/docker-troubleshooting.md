# TechNova Website – Troubleshooting

## Issue: Port Already in Use
**Symptom:** `port is already allocated`
**Fix:** Stop the conflicting container or change the port.

## Issue: Website Not Reachable
**Symptom:** `curl` returns connection refused
**Fix:** Check port mapping with `docker port technova-web`

## Issue: Container Not Starting
**Symptom:** `docker ps` shows no container
**Fix:** Check logs with `docker logs technova-web`
