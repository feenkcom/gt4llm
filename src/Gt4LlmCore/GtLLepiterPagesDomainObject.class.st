Class {
	#name : #GtLLepiterPagesDomainObject,
	#superclass : #GtLDomainObject,
	#instVars : [
		'pages'
	],
	#category : #'Gt4LlmCore-Domain Objects'
}

{ #category : #visiting }
GtLLepiterPagesDomainObject >> acceptVisitor: aVisitor [
	^ aVisitor visitLepiterPagesDomainObject: self
]

{ #category : #'gt - extensions' }
GtLLepiterPagesDomainObject >> gtPagesFor: aView [
	<gtView>
	<gtLlmView>
	pages ifNil: [ ^ aView empty ].
	^ aView columnedList
		title: 'Pages';
		items: [ self pages ];
		column: 'Value' text: [ :each | each gtDisplayString ]
]

{ #category : #accessing }
GtLLepiterPagesDomainObject >> pages [
	^ pages ifNil: [ #() ]
]

{ #category : #accessing }
GtLLepiterPagesDomainObject >> pages: anObject [
	pages := anObject
]

{ #category : #'api - serializing' }
GtLLepiterPagesDomainObject >> serializeToOpenAIResponseJsonObject [
	"Return a JSON dictionary that represents the domain object."

	<return: #NeoJSONObject>
	^ NeoJSONObject new
		at: #pages
			put: (self pages
					collect: [ :eachPage | 
						NeoJSONObject new
							at: #pageTitle put: eachPage title;
							at: #uuid put: eachPage uid asString36;
							yourself ]);
		yourself
]
