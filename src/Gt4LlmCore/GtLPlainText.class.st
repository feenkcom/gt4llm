Class {
	#name : #GtLPlainText,
	#superclass : #Object,
	#instVars : [
		'content'
	],
	#category : #'Gt4LlmCore-Formats'
}

{ #category : #accessing }
GtLPlainText >> addContentOneLineSummaryTo: aWriteStream [
	self content ifNotNil: [ :aString | aWriteStream nextPutAll: aString asString ]
]

{ #category : #accessing }
GtLPlainText >> content [
	^ content
]

{ #category : #accessing }
GtLPlainText >> content: anObject [
	content := anObject
]

{ #category : #accessing }
GtLPlainText >> contentDescription [
	<magritteDescription>
	^ MAStringDescription new
		accessor: #content;
		comment: 'Plain text';
		beRequired
]

{ #category : #printing }
GtLPlainText >> gtDisplayOn: stream [ 
	content gtDisplayOn: stream 
]

{ #category : #'as yet unclassified' }
GtLPlainText >> gtMarkdownFor: aView [
	<gtView>
	<gtLlmView>
	content isEmptyOrNil ifTrue: [ ^ aView empty ].
	^ aView textEditor
		title: 'Text';
		priority: 1;
		styler: GtLMessageStyler new;
		text: [ content ];
		actionButtonIcon: LeIcons lepiterIcon
			tooltip: 'Create page from Text'
			action: [ :b | 
				b phlow
					spawnObject: (LeDatabasesRegistry defaultPrimaryDatabase addPage: (LePage new addSnippet: (LeTextSnippet new string: content); yourself)) ];
		actionButtonIcon: BrGlamorousVectorIcons clipboard
			tooltip: 'Copy contents to clipboard'
			action: [ :b | 
				GtClipboard clipboardText: content ]
]

{ #category : #'llm-views' }
GtLPlainText >> llmRawDataViewFor: aDataView [
	<gtLlmDataView>
	
	^ aDataView magritteObject: [ self ]
]
