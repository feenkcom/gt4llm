Class {
	#name : #LeLlmSnippet,
	#superclass : #LeTextualSnippet,
	#category : #'Gt4Llm-Lepiter-Model'
}

{ #category : #'as yet unclassified' }
LeLlmSnippet class >> empty [

	^ self new
]

{ #category : #ui }
LeLlmSnippet >> gtCopySerialisationFor: anAction [
	"Copy the serialisation of the receiver to the clipboard.
	This can then be pasted as a snippet from a lepiter page."
	<gtAction>

	^ anAction button
		icon: BrGlamorousVectorIcons copyToClipboard;
		tooltip: 'Copy the snippet definition to the clipboard';
		action: [ :button | self copySerialisationToClipboard ]
]
