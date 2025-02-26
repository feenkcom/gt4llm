Class {
	#name : #GtLlmCompositeMessage,
	#superclass : #GtLlmUserMessage,
	#instVars : [
		'serializeInline'
	],
	#category : #Gt4Llm
}

{ #category : #'as yet unclassified' }
GtLlmCompositeMessage >> addFile: aFileReference [
	| fileId |
	fileId := (self chat client uploadFile: aFileReference withPurpose: 'vision')
			id.
	content
		add: (GtLlmFileMessagePart new
				fileId: fileId;
				file: aFileReference)
]

{ #category : #'as yet unclassified' }
GtLlmCompositeMessage >> addString: aString [
	content add: (GtLlmStringMessagePart new string: aString)
]

{ #category : #'as yet unclassified' }
GtLlmCompositeMessage >> content [
	^ serializeInline
		ifTrue: [ content serializeInline ]
		ifFalse: [ content serialize ]
]

{ #category : #'as yet unclassified' }
GtLlmCompositeMessage >> contentText [
	^ ''
		join: ((content select: [ :aContent | aContent isString ]) collect: #string)
]

{ #category : #'as yet unclassified' }
GtLlmCompositeMessage >> gtMessagePartsFor: aView [
	<gtView>
	<gtLlmMessageView>
	^ aView columnedList
		title: 'Message parts';
		priority: 3;
		items: [ content ];
		column: 'Type' text: #type;
		column: 'Content' text: #content weight: 3
]

{ #category : #'as yet unclassified' }
GtLlmCompositeMessage >> initialize [
	super initialize.
	content := GtLlmMessagePartGroup new.
	serializeInline := false
]

{ #category : #'as yet unclassified' }
GtLlmCompositeMessage >> serializeInline [
	serializeInline := true
]
