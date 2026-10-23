"
Examples for sending file attachments without making network requests.
"
Class {
	#name : #GtLChatFileSendingExamples,
	#superclass : #GtLChatWithOpenAIProviderStubExamples,
	#category : #'Gt4Llm-OpenAI-Examples'
}

{ #category : #examples }
GtLChatFileSendingExamples >> rejectUnsupportedFiles [
	<gtExample>
	| chat |
	chat := self chatWithOpenAIProviderStub.
	#('archive.zip' 'unknown.noSuchMimeType' 'noExtension') do: [ :name |
		| rejected |
		rejected := false.
		[ chat
			sendFiles: { FileSystem memory root / 'notes.txt'. FileSystem memory root / name }
			withMessage: 'Must not send' ]
			on: Error do: [ :error | rejected := true ].
		self assert: rejected.
		self assert: chat messages isEmpty ].
	^ chat
]

{ #category : #examples }
GtLChatFileSendingExamples >> sendSupportedFiles [
	<gtExample>
	| chat files models |
	chat := self chatWithOpenAIProviderStub.
	files := #('picture.PNG' 'document.pdf' 'notes.txt' 'data.json' 'vector.svg')
		collect: [ :name | (FileSystem memory root / name) ensureCreateFile ].
	chat sendFiles: files withMessage: 'Attached files'.
	models := chat messages first inputModels.
	self assert: models size equals: 6.
	self assert: models first model content equals: 'Attached files'.
	models allButFirst with: { GtLImageFile. GtLPdfFile. GtLTextFile. GtLTextFile. GtLImageFile }
		do: [ :model :expectedClass | self assert: model model class equals: expectedClass ].
	models allButFirst with: files
		do: [ :model :file | self assert: model model fileReference equals: file ].
	^ chat
]

{ #category : #examples }
GtLChatFileSendingExamples >> sendWithoutFiles [
	<gtExample>
	| chat |
	chat := self chatWithOpenAIProviderStub.
	chat sendFiles: #() withMessage: 'Just text'.
	self assert: chat messages first inputModels size equals: 1.
	self assert: chat messages first inputModels first model content equals: 'Just text'.
	^ chat
]
