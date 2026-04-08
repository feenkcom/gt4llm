Class {
	#name : #GtLLepiterEditSnippetTransformationSpecification,
	#superclass : #GtLLepiterSnippetTransformationSpecification,
	#instVars : [
		'snippetUid'
	],
	#category : 'Gt4LlmCore-Formats'
}

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
	^ LeDatabasesRegistry defaultLogicalDatabase 
		pageWithID: self pageUid
		ifPresent: [ :aPage |
			aPage allChildrenBreadthFirstDo: [ :aSnippet | 
				(aSnippet uid = self snippetUid) 
					ifTrue: [ ^ aSnippet ] ].
					
			Error signal: 'Could not locate snippet with id ', self snippetUid asString ] 
		ifAbsent: [ 
			Error signal: 'Could not locate page with id ', self pageUid asString]
]
