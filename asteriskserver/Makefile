AUDIO_ASSETS_DIR = assets/sounds/futel/longmont
AUDIO_DEST_DIR = src/var/lib/asterisk/sounds/futel/longmont

audio:
	ruby scripts/update_audio_assets.rb $(AUDIO_DEST_DIR) $(AUDIO_ASSETS_DIR)

clean:
	rm -r $(AUDIO_DEST_DIR)/*
