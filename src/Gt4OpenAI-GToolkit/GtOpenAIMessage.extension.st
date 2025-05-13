Extension { #name : #GtOpenAIMessage }

{ #category : #'*Gt4OpenAI-GToolkit' }
GtOpenAIMessage >> messageFiles [
	self contentText = self content ifTrue: [ ^ GtOpenAIFilesGroup new ].

	^ self content
		select: [ :aValue | (aValue at: 'type') = 'input_image' ]
		thenCollect: [ :aValue | 
			| byteArray |
			byteArray := ((aValue at: 'image_url')
					removePrefix: 'data:image/jpeg;base64,') base64Decoded.
			SkiaImage
				fromBuffer: byteArray
				start: 0
				end: byteArray size - 1 ]
]
