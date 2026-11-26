Class {
	#name : #GtLLepiterEditSnippetTransformationSpecification,
	#superclass : #GtLLepiterSnippetTransformationSpecification,
	#instVars : [
		'snippetUid'
	],
	#category : #'Gt4LlmCore-Formats'
}

{ #category : #accessing }
GtLLepiterEditSnippetTransformationSpecification class >> refactoringName [
	^ 'Edit snippet'
]

{ #category : #accessing }
GtLLepiterEditSnippetTransformationSpecification >> refactoringDescription [
	^ self refactoringName , ' '
		, (self snippetUid ifNil: [ '' ] ifNotNil: [ :anUid | anUid uidString ])
		, ' in ' , self pageDescription
]

{ #category : #accessing }
GtLLepiterEditSnippetTransformationSpecification >> snippetUid [
	^ snippetUid
]

{ #category : #accessing }
GtLLepiterEditSnippetTransformationSpecification >> snippetUid: anUid [
	snippetUid := anUid
]

{ #category : #descriptions }
GtLLepiterEditSnippetTransformationSpecification >> snippetUidDescription [
	<magritteDescription>
	
	^ MAToOneRelationDescription new
			accessor: #snippetUid;
			comment: 'The id uniquely identifying this snippet with a Lepiter knowledge base';
			classes: { LeUID};
			beRequired
]

{ #category : #accessing }
GtLLepiterEditSnippetTransformationSpecification >> targetSnippet [
	"Return the snippet to edit. A page and snippet id pair that is in several databases, or a snippet id that the page holds twice, is refused, as by the Lepiter snippet tools"

	^ (GtLLepiterSnippetLocator database: self database)
		snippetWithUid: (self snippetUid ifNotNil: [ :anUid | anUid uidString ])
		pageUid: self pageUid asString36
		databaseId: nil
		ifFound: [ :aSnippet | aSnippet ]
		ifNone: [ :aProblem | Error signal: aProblem errorMessage ]
]
