NAME="obc/dev-env"
IMAGE= openchain-devbase.box

all: $(IMAGE)

$(IMAGE):
	vagrant destroy -f
	vagrant up
	vagrant package --output $@
	vagrant destroy -f

install: $(IMAGE) remove
	vagrant box add -name $(NAME) $(IMAGE)

remove:
	-vagrant box remove --box-version 0 $(NAME)

clean: remove
	-rm $(IMAGE)
