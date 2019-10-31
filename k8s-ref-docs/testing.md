# Piece of mind testing

## Manual vs script

1. Fetch 1.15 branch into 'manual' directory
1. Manually generate API and kubectl docs based on master
1. View changes between 1.15 and master
1. Update docs if needed


1. Fetch 1.15 branch into 'automated' directory
1. Fetch master version of script and yaml
1. Create virtual environment with Python 3.6 (follow instructions in doc)
1. Run script targeted at 1.16
1. Compare with manually generated docs
