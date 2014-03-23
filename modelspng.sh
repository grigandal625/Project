#!/bin/bash
railroady -o models.dot -M
dot -Tpng models.dot > models.png
