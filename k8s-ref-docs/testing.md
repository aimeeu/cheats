# Piece of mind testing

## Manual vs script

1. Fetch 1.15 branch into 'manual' directory
1. Manually generate API and kubectl docs based on master
1. View changes between 1.15 and master
1. Update docs if needed


1. Fetch 1.15 branch into 'automated' directory
1. Create virtual environment with Python 2.7 (follow instructions in doc)
1. Run script
1. Compare with manually generated docs
