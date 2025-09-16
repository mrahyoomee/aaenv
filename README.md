# zpreztoをインストール
手順は下記に従う。cloneするとき--depthくらいは設定して良い。
元々~/.zshrcがある場合はバックアップしておく。

https://github.com/sorin-ionescu/prezto

# 設定ファイルの上書き
~/.zprezto/runcomsのzshrcとzpreztorcを上書きする。

	cp zprezto zpreztorc ~/.zprezto/runcoms

# テーマ
powerlevel10kを使う前提になっているので、適当にドキュメントに従って変えてもよい。
zshrcとzpreztorcファイルの中で"10k"で検索したあたり。
powerlevel10kを使う場合はドキュメント内に記載のフォントを入れたほうが良い。

https://github.com/romkatv/powerlevel10k?tab=readme-ov-file#meslo-nerd-font-patched-for-powerlevel10k

zshの初回起動時にテーマの細かい設定を促される。やり直したかったら下記コマンド。

	p10k configure

# ローカルのバイナリやスクリプトのパス

zshrcで.local/binにパスを設定しているので、バイナリをコピーしておく。
pecoを使う場合など。(pecoはaptでなくて公式から最新版をダウンロードするのが良い)

# .local/env
zshrcでファイル名固定で読み込んでいるので、必要に応じてディレクトリにコピーする。

* local.sh 自分で使う環境用の設定や関数を書いておく。
* env.sh 個人や会社で固有の設定や関数など共有したくない設定を書いておく。
* anyenv_path.sh anyenvが入っていたらパスを設定
* peco_env.sh Ctrl+rでhistory検索、Ctrl+tでディレクトリ移動の検索
* peco_anyenv.sh pecoでanyenvで使うenvのバージョン指定

# zsh起動
zshを起動して問題なければOK。
chshでデフォルトシェルを変更しても良い。

# インストールするもの

* 日本語環境

  sudo apt install -y language-pack-ja-base language-pack-ja

* pyenvで入れるpythonのビルド

  sudo apt install -y flex bison byacc make m4 autoconf unzip build-essential python3-dev git g++ wget

* 便利なツール類

    sudo apt install zoxide fzf eza zoxide ripgrep bat fd-find delta hyperfine hexyl lnav btop tldr gping httpie

