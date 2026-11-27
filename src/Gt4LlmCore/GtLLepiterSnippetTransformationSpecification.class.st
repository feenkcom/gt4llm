Class {
	#name : #GtLLepiterSnippetTransformationSpecification,
	#superclass : #GtLLepiterTransformationSpecification,
	#instVars : [
		'pageUidString'
	],
	#category : #'Gt4LlmCore-Formats'
}

{ #category : #accessing }
GtLLepiterSnippetTransformationSpecification >> page [
	"Return my page. A page id that is in several databases is refused, as by the Lepiter snippet tools"

	^ self
		pageIfFound: [ :aPage | aPage ]
		ifNone: [ :aProblem | Error signal: aProblem errorMessage ]
]

{ #category : #accessing }
GtLLepiterSnippetTransformationSpecification >> pageDescription [
	"Name my page in a description: by its title, or by its uid when it cannot be found"

	^ self
		pageIfFound: [ :aPage | 'page ' , aPage title asString ]
		ifNone: [ :aProblem | 'page ' , self pageUidString asString ]
]

{ #category : #accessing }
GtLLepiterSnippetTransformationSpecification >> pageIfFound: aFoundBlock ifNone: aNoneBlock [
	"Look my page up in my database. aNoneBlock gets an error domain object when the uid is invalid, the page is not found or its id is in several databases"

	| aUuid |
	aUuid := [ self pageUid ]
			on: Error
			do: [ :anError | 
				^ aNoneBlock
					value: (GtLProblemDomainObject new
							errorMessage: 'Invalid page uid ' , self pageUidString printString;
							yourself) ].
	^ (GtLLepiterSnippetLocator database: self database)
		pageWithUid: aUuid asString36
		databaseId: nil
		ifFound: aFoundBlock
		ifNone: aNoneBlock
]

{ #category : #accessing }
GtLLepiterSnippetTransformationSpecification >> pageUid [
	^ UUID gtFromString: self pageUidString 
]

{ #category : #accessing }
GtLLepiterSnippetTransformationSpecification >> pageUidString [
	^ pageUidString
]

{ #category : #accessing }
GtLLepiterSnippetTransformationSpecification >> pageUidString: anObject [
	pageUidString := anObject
]

{ #category : #descriptions }
GtLLepiterSnippetTransformationSpecification >> pageUidStringDescription [
	<magritteDescription>
	
	^ MAStringDescription new
		  accessor: #pageUidString;
		  withUUIDFormatCommentWith: 'The uid of the page containing the snippet to edit.';
		  beRequired
]
