Class {
	#name : #GtLlmModelFile,
	#superclass : #Object,
	#instVars : [
		'directives'
	],
	#category : #'Gt4Llm-Modelfiles'
}

{ #category : #accessing }
GtLlmModelFile >> adapter: aString [ 
	self addDirective: (GtLlmAdapterDirective withText: aString)
]

{ #category : #accessing }
GtLlmModelFile >> addDirective: aDirective [
	directives add: aDirective
]

{ #category : #accessing }
GtLlmModelFile >> addMessage: aMessage [
	self
		addDirective: ((GtLlmMessageDirective withText: aMessage role)
				messageText: aMessage content)
]

{ #category : #accessing }
GtLlmModelFile >> content [
	^ '

' join: (self directives collect: #directiveString)
]

{ #category : #accessing }
GtLlmModelFile >> directives [
	^ directives
]

{ #category : #accessing }
GtLlmModelFile >> from: aModel [
	self addDirective: (GtLlmFromDirective withText: aModel)
]

{ #category : #accessing }
GtLlmModelFile >> gtContentFor: aView [
	<gtView>
	^ aView textEditor
		title: 'Content';
		priority: 1;
		text: [ self content ]
]

{ #category : #accessing }
GtLlmModelFile >> gtDirectivesFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Directives';
		priority: 2;
		items: [ self directives ];
		column: 'Kind' text: #directiveKind;
		column: 'Text' text: #directiveText
]

{ #category : #accessing }
GtLlmModelFile >> initialize [
	directives := OrderedCollection new
]

{ #category : #accessing }
GtLlmModelFile >> license: aString [
	self addDirective: (GtLlmLicenseDirective withText: aString)
]

{ #category : #accessing }
GtLlmModelFile >> messageFrom: aString withText: aText [
	self
		addDirective: ((GtLlmMessageDirective withText: aString) messageText: aText)
]

{ #category : #accessing }
GtLlmModelFile >> parameter: aString at: anObject [
	self
		addDirective: ((GtLlmParameterDirective withText: aString) value: anObject)
]

{ #category : #accessing }
GtLlmModelFile >> system: aModel [
	self addDirective: (GtLlmSystemDirective withText: aModel)
]

{ #category : #accessing }
GtLlmModelFile >> template: aString [ 
	self addDirective: (GtLlmTemplateDirective withText: aString)
]
