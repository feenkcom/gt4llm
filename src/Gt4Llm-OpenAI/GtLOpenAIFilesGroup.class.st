Class {
	#name : #GtLOpenAIFilesGroup,
	#superclass : #GtLOpenAIGroup,
	#category : #'Gt4Llm-OpenAI'
}

{ #category : #accessing }
GtLOpenAIFilesGroup class >> itemClass [
	^ GtLOpenAIFile
]

{ #category : #accessing }
GtLOpenAIFilesGroup >> gtFilesFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Files';
		priority: 1;
		items: [ self items ];
		column: 'ID' text: #id;
		column: 'Filename' text: #filename;
		column: 'Size'
			text: #bytes
			weight: 0.5;
		column: 'Created at'
			text: #createdAt
			weight: 0.5;
		column: 'Purpose'
			text: #purpose
			weight: 0.5;
		column: 'Status'
			text: #status
			weight: 0.5;
		contextItemLabel: 'Copy id'
			action: [ :anElement :each | GtClipboard clipboardText: each id ];
		contextItemLabel: 'Delete file'
			action: [ :anElement :each | 
				each deleteFile.
				anElement phlow fireViewUpdateWish ]
]

{ #category : #'as yet unclassified' }
GtLOpenAIFilesGroup >> requestResponse: aGtLRequestResponse [ 
	"do nothing"
]
