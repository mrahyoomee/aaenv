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
powerlevel10kを使う場合はお勧めフォントを入れたほうが良い。

https://github.com/romkatv/powerlevel10k?tab=readme-ov-file#meslo-nerd-font-patched-for-powerlevel10k

zshの初回起動時にテーマの細かい設定を促される。やり直したかったら下記コマンド。

	p10k configure

# pecoとghqの導入
golangで実装されたクリメントサーチできるプログラムで、便利なので入れておく。
aptで入るバージョンは文字化けするのでマニュアルで入れる。

https://github.com/peco/peco/releases

zshrcで.local/binにパスを設定しているので、バイナリをコピーしておく。

# .bin/localの中
ディレクトリ自体にパスを通してあるので、何かプログラムにパスを通したい時はここに置く

* local.sh 自分で使う環境用の設定や関数を書いておく。
* env.sh 個人や会社で固有の設定や関数など共有したくない設定を書いておく。

# zsh起動
zshを起動して問題なければOK。
chshでデフォルトシェルを変更しても良い。

# インストールするもの

* 日本語環境

  sudo apt install -y language-pack-ja-base language-pack-ja

* pyenvで入れるpythonのビルド

  sudo apt install -y flex bison byacc make m4 autoconf unzip build-essential python3-dev git g++ wget


