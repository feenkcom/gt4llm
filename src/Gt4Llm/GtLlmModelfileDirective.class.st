Class {
	#name : #GtLlmModelfileDirective,
	#superclass : #Object,
	#instVars : [
		'text'
	],
	#category : #'Gt4Llm-Modelfiles'
}

{ #category : #accessing }
GtLlmModelfileDirective class >> withText: aString [
	^ self new text: aString
]

{ #category : #'as yet unclassified' }
GtLlmModelfileDirective >> directiveAssociation [
	^ self directiveKind asLowercase -> self directiveText
]

{ #category : #accessing }
GtLlmModelfileDirective >> directiveKind [
	^ self subclassResponsibility
]

{ #category : #accessing }
GtLlmModelfileDirective >> directiveString [
	^ self directiveKind, ' ', self directiveText
]

{ #category : #accessing }
GtLlmModelfileDirective >> directiveText [
	^ self treatText
]

{ #category : #accessing }
GtLlmModelfileDirective >> text [
	^ text
]

{ #category : #accessing }
GtLlmModelfileDirective >> text: anObject [
	text := anObject
]

{ #category : #accessing }
GtLlmModelfileDirective >> treatText [
	"a hook to enable custom text treatment. default: quoting"
	^ '"""', self text, '"""'
]
