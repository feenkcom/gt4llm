Extension { #name : #GtOpenAIUploadFileAPIClient }

{ #category : #'*Gt4OpenAI-GToolkit' }
GtOpenAIUploadFileAPIClient >> fileToEntity [
	"todo: what would be better here?"

	(self file isKindOf: GtLlmFineTuningFile)
		ifTrue: [ ^ ZnEntity with: self file contents type: 'application/jsonl' ].
	^ ZnEntity bytes: self file binaryContents
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
