Extension { #name : #GtOpenAIUploadFileAPIClient }

{ #category : #'*Gt4OpenAI-GToolkit' }
GtOpenAIUploadFileAPIClient >> fileToEntity [
	| extension mimeType |
	(self file isKindOf: GtLlmFineTuningFile)
		ifTrue: [ ^ ZnEntity with: self file contents type: 'application/jsonl' ].

	extension := self file extension ifNil: ''.
	mimeType := ({'png' -> 'image/png'.
			'jpg' -> 'image/jpeg'.
			'jpeg' -> 'image/jpeg'.
			'gif' -> 'image/gif'.
			'txt' -> 'text/plain'.
			'csv' -> 'text/csv'.
			'json' -> 'application/json'} asDictionary
			at: extension asLowercase
			ifAbsent: [ 'application/octet-stream' ]) asZnMimeType.

	^ (ZnEntity bytes: self file binaryContents) contentType: mimeType
]

{ #category : #'*Gt4OpenAI-GToolkit' }
GtOpenAIUploadFileAPIClient >> request [
	^ self client
		postFile: '/files'
		withEntity: (ZnMultiPartFormDataEntity new
				addPart: (ZnMimePart fieldName: 'purpose' value: self purpose);
				addPart: (ZnMimePart
						fieldName: 'file'
						fileName: self file basename
						entity: self fileToEntity);
				yourself)
]
