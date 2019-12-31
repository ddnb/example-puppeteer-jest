#!/bin/bash

readonly NAME="puppeteer"
readonly LOCALHOST="127.0.0.1"
readonly FULL_PATH="$( cd "$( dirname "$0" )" && pwd )"

helps() {
	case $1 in
		all|*) allhelps ;;
	esac
}

allhelps() {
cat <<EOF
💡 Usage: ./help.sh COMMAND
[help|usage|build|init|up|down|restart|status|logs|ssh]
[CLI]
  build        Build docker service
  up or start  Run docker-compose as daemon (or up)
  down or stop Terminate all docker containers run by docker-compose (or down)
  restart      Restart docker-compose containers
  status       View docker containers status
  logs         View docker containers logs
  ssh          ssh cli
EOF
}

# Usage
usage() {
	echo "Usage:"
	echo "${0} [help|usage|build|init|up|down|restart|status|logs|ssh]"
}

# run init
run_init() {
	echo "$1 $2 $3 $4 $5"
	case $2 in
		*|env|hosts)
			rsync -avz ${FULL_PATH}/env ${FULL_PATH}/.env
		;;
  esac
}

# run build
build() {
	docker-compose build
}

# run start
start() {
	docker-compose up -d
}

# run down
stop() {
	docker-compose down
}

# run restart
restart() {
	docker-compose restart
}

# run status
status() {
	docker-compose ps
}

# run logs
logs() {
	case $1 in
		nginx) 
			docker-compose logs nginx

			printf "\n--- access log ---\n"
			cat ./docker/log/nginx/access.log

			printf "\n--- error log ---\n"
			cat ./docker/log/nginx/error.log
		;;
		cleanup|clean)
			rm -rfv ./docker/logs/nginx
		;;
		php|*) docker-compose logs ;;
	esac
}

# run ssh
run_ssh() {
	case $1 in
		nginx) 
			docker-compose exec nginx /bin/bash 
		;;
		*)
			docker-compose exec ${NAME} /bin/bash 
		;;
	esac
}

# run cli
run_cli() {
	echo "Bash version ${BASH_VERSION}..."
	for i in {1..10}
	do
		echo "${!i}"
	done

	case $2 in
		rsync)
			case $3 in
				env_host|bash_profile|bash|profile)
					rsync -avz  ${FULL_PATH}/env_host ~/.bash_profile;
				;;
				env|*)
				;;
			esac
		;;
		cleanup|clean)
			case $3 in
				all|*)
					sudo killall Chromium
				;;
			esac
		;;
    spec|demo)
      case $3 in
				*)
					docker-compose exec -T ${NAME} /bin/bash -c "yarn test /code/$3"
				;;
			esac
    ;;
		test)
			case $3 in
				jest)
					 readonly TEST_SRC_JEST="yarn test src/tests/src/component/jest.test.js"
						docker-compose exec -T ${NAME} /bin/bash -c "$TEST_SRC_JEST"
				;;
				list)
					LIST_TEST="yarn test -o --lastCommit --listTests"

					docker-compose exec -T ${NAME} /bin/bash -c  "$LIST_TEST"
				;;
				last)
					LIST_TEST="yarn test -o --lastCommit --listTests"
					TEST_LAST_COMMIT="yarn test -o --lastCommit"

					docker-compose exec -T ${NAME} /bin/bash -c  "$LIST_TEST"
					docker-compose exec -T ${NAME} /bin/bash -c  "$TEST_LAST_COMMIT"
				;;
				app|applicant|applicants)
					case $4 in
            all)
              readonly TEST_APP="yarn test src/tests/applicants"
							docker-compose exec -T ${NAME} /bin/bash -c "$TEST_APP"
            ;;
						*)
							docker-compose exec -T ${NAME} /bin/bash -c "yarn test ${5}"
						;;
					esac
				;;
				src)
					readonly TEST_SRC="yarn test src/tests/src"
					docker-compose exec -T ${NAME} /bin/bash -c "$TEST_SRC"
				;;
				*)
					docker-compose exec -T ${NAME} /bin/bash -c "yarn test /code/$3"
				;;
			esac
		;;
		example-puppeteer|*) 
		  docker-compose exec -T ${NAME} /bin/bash -c \
			  " \
				${2} ${3} ${4} ${5} ${6} ${7} ${8} ${9} ${10} \
				${11} ${12} ${13} ${14} ${15} ${16} ${17} ${18} ${19} ${20} \
		    ${21} ${22} ${23} ${24} ${25} ${26} ${27} ${28} ${29} ${30} \
		    ${31} ${32} ${33} ${34} ${35} ${36} ${37} ${38} ${39} ${40}
				"
		;;
	esac
}

# run memo
run_memo() {
	case $1 in
		*)
		;;
	esac
}

# run brew
run_brew() {
	echo "Bash version ${BASH_VERSION}..."
	for i in {1..10}
	do
		echo "${!i}"
	done

	case $2 in
		start)
		  # brew services start dnsmasq
			sudo brew services start dnsmasq
		;;
		list|status)
			brew services list
		;;
	esac
}

case $1 in
	brew) 
	  run_brew \
		${1} ${2:example-puppeteer} ${3} ${4} ${5} ${6} ${7} ${8} ${9} ${10} \
		${11} ${12} ${13} ${14} ${15} ${16} ${17} ${18} ${19} ${20} \
		${21} ${22} ${23} ${24} ${25} ${26} ${27} ${28} ${29} ${30} \
		${31} ${32} ${33} ${34} ${35} ${36} ${37} ${38} ${39} ${40}
	;;

	memo)
		run_memo ${2:-example-puppeteer}
	;;

  cli) 
	  run_cli \
		${1} ${2:example-puppeteer} ${3} ${4} ${5} ${6} ${7} ${8} ${9} ${10} \
		${11} ${12} ${13} ${14} ${15} ${16} ${17} ${18} ${19} ${20} \
		${21} ${22} ${23} ${24} ${25} ${26} ${27} ${28} ${29} ${30} \
		${31} ${32} ${33} ${34} ${35} ${36} ${37} ${38} ${39} ${40}
	;;

	init)
		run_init \
		  ${1} ${2:-env} ${3} ${4} ${5}
	;;

	build) 
		build 
	;;

	start|up) 
		start 
	;;

	stop|down) 
		stop 
	;;

	restart|reboot) 
		restart
	;;

	status|ps)
		status
	;;

	logs)
		logs ${2:-all}
	;;

	ssh)
		run_ssh ${2:-example-puppeteer}
	;;
	
	*)
		helps
	;;
esac