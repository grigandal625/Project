#!/bin/bash
railroady -o models.dot -M
dot -Tsvg models.dot
