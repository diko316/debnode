#!/bin/sh

rsync -rpDzh --exclude=".git*" --exclude="*node_modules/*" "${APP_SOURCE}" "${PROJECT_ROOT}/"
