#Rubyのバージョンは3.1.3
#ディストリビューションはdebian系を選択する。
FROM ruby:3.2.2-slim-bookworm

#シェルをbashにする。
SHELL ["/bin/bash","-c"]

#docker compose file経由で.envファイルの変数を参照する。
ARG GROUP_ID
ARG GROUP_NAME
ARG USER_ID
ARG USER_NAME
#一般ユーザを追加する。
RUN groupadd -g ${GROUP_ID} ${GROUP_NAME} \
 && useradd -m -s /bin/bash -u ${USER_ID} -g ${GROUP_ID} ${USER_NAME}

#ツールを追加でインストールする。
RUN apt-get update && apt-get upgrade -y \
 && apt-get install -y x11-apps curl wget sqlite3 libsqlite3-dev

#ユーザを切り替える。
USER ${USER_NAME}

#Rubygemを追加する。
RUN gem update --system \
 && gem install activerecord \
 && gem install sqlite3

#作業ディレクトリをホームに設定する。
WORKDIR ${WORK_DIR}

CMD ["/bin/bash"]