#!/bin/bash
# Docker Automation Script - AWS EC2
# Author: <your-name>

# ----- Color codes -----
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

while true; do
    clear
    echo -e "${YELLOW}=========== Docker Automation Menu ===========${NC}"
    echo "1. Launch a container"
    echo "2. List all containers"
    echo "3. Inspect a container"
    echo "4. Stop a container"
    echo "5. Remove a container"
    echo "6. Prune unused containers"
    echo "7. Show Docker info"
    echo "8. Remove ALL containers (force)"
    echo "9. Exit"
    echo -e "${YELLOW}==============================================${NC}"
    read -p "Enter your choice [1-9]: " choice

    case $choice in
        1)
            echo -e "${GREEN}--- Launch a Container ---${NC}"
            read -p "Enter image name (e.g., nginx:latest): " image
            read -p "Enter container name: " cname
            if docker run -dit --name "$cname" "$image"; then
                echo -e "${GREEN}Container '$cname' launched successfully!${NC}"
            else
                echo -e "${RED}Failed to launch container.${NC}"
            fi
            ;;

        2)
            echo -e "${GREEN}--- Listing all containers ---${NC}"
            docker ps -a || echo -e "${RED}Failed to list containers.${NC}"
            ;;

        3)
            echo -e "${GREEN}--- Inspect a Container ---${NC}"
            read -p "Enter container ID/name: " cid
            docker inspect "$cid" || echo -e "${RED}Inspection failed.${NC}"
            ;;

        4)
            echo -e "${GREEN}--- Stop a Container ---${NC}"
            read -p "Enter container ID/name to stop: " cid
            if docker stop "$cid"; then
                echo -e "${GREEN}Container stopped.${NC}"
            else
                echo -e "${RED}Failed to stop container.${NC}"
            fi
            ;;

        5)
            echo -e "${GREEN}--- Remove a Container ---${NC}"
            read -p "Enter container ID/name to remove: " cid
            if docker rm "$cid"; then
                echo -e "${GREEN}Container removed.${NC}"
            else
                echo -e "${RED}Failed to remove container.${NC}"
            fi
            ;;

        6)
            echo -e "${GREEN}--- Prune Unused Containers ---${NC}"
            read -p "Are you sure you want to prune unused containers? [y/N]: " confirm
            if [[ $confirm == [yY] ]]; then
                docker container prune -f
                echo -e "${GREEN}Prune complete.${NC}"
            else
                echo -e "${YELLOW}Operation cancelled.${NC}"
            fi
            ;;

        7)
            echo -e "${GREEN}--- Docker Information ---${NC}"
            docker info || echo -e "${RED}Could not retrieve Docker info.${NC}"
            ;;

        8)
            echo -e "${RED}--- Remove ALL Containers (Force) ---${NC}"
            read -p "Are you sure you want to REMOVE ALL containers? [y/N]: " confirm
            if [[ $confirm == [yY] ]]; then
                if docker rm -f $(docker ps -aq) 2>/dev/null; then
                    echo -e "${GREEN}All containers removed!${NC}"
                else
                    echo -e "${YELLOW}No containers to remove or command failed.${NC}"
                fi
            else
                echo -e "${YELLOW}Operation cancelled.${NC}"
            fi
            ;;

        9)
            echo -e "${YELLOW}Exiting...${NC}"
            exit 0
            ;;

        *)
            echo -e "${RED}Invalid choice! Please select 1-9.${NC}"
            ;;
    esac

    echo
    read -p "Press Enter to return to menu..."
done
