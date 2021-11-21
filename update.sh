#!/usr/bin/env bash
if test -f "repos"; then
	rm -r repos
fi
touch repos
if test -f "forks"; then
	rm -r forks
fi
touch forks


repos=( $(curl -s https://api.github.com/users/Pigmy-penguin/repos | grep -wv '"name": "MIT\|GNU\|Other\|Do\|Pigmy' | grep name | cut -d'"' -f4) )

for repo in ${repos[*]} 
do
    fork=$(curl -s https://api.github.com/repos/Pigmy-penguin/$repo | grep fork | head -n 1 | cut -d':' -f2)
    desc=$(curl -s https://api.github.com/repos/Pigmy-penguin/$repo | grep description | head -n 1 | cut -d'"' -f4)
    if [ "$fork" = " false," ]; then
	    echo "$repo was not forked - $desc"
	    echo "$repo[$desc" >> repos
    else
	    echo "$repo was forked - $desc"
	    echo "$repo[$desc" >> forks
    fi
done

if test -f "index.md"; then
	rm -r index.md
fi
echo "---" > index.md
echo "layout: home" >> index.md
echo "permalink: /" >> index.md
echo "permalink_name: /home" >> index.md
echo "title: Pigmy-penguin Homepage" >> index.md
echo -e "---\n" >> index.md
echo -e "## My repositories:\n" >> index.md
linescount=$(wc -l repos | sed s/" +"/""/g | sed s/"[a-z]"//g | sed s/" "//g)
for i in $(seq 1 $linescount)
do
	name=$(cat repos | head -n $i repos | tail -n+$i | cut -d'[' -f1)
	desc=$(cat repos | head -n $i repos | tail -n+$i | cut -d'[' -f2)
	echo -e "[**$name**](https://github.com/Pigmy-penguin/$name) - $desc\n" >> index.md  
done
echo "## My forks:" >> index.md
echo -e "### Open source projects I contributed to\n" >> index.md
linescount=$(wc -l forks | sed s/" +"/""/g | sed s/"[a-z]"//g | sed s/" "//g)
for i in $(seq 1 $linescount)
do
	name=$(cat forks | head -n $i forks | tail -n+$i | cut -d'[' -f1)
	desc=$(cat forks | head -n $i forks | tail -n+$i | cut -d'[' -f2)
	echo -e "[**$name**](https://github.com/Pigmy-penguin/$name) - $desc\n" >> index.md  
done

echo -e "\nLast updated at: $(date +'%H:%M:%S')" >> index.md
