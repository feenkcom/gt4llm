"
I reuse the standard summarizer tab update actions with the ACP session's collector for summarizer-specific inspector views.
"
Class {
	#name : #GtLACPChangeSummarizersTabAction,
	#superclass : #GtLPhlowChangeTabGroupModifySummarizersTabAction,
	#instVars : [
		'session'
	],
	#category : #'Gt4Llm-ACP-UI'
}

{ #category : #updating }
GtLACPChangeSummarizersTabAction >> collectSummarizedViewsFor: summarizers [
 ^ session summarizerViewsFor: summarizers inContext: GtPhlowContext new
]

{ #category : #accessing }
GtLACPChangeSummarizersTabAction >> session: aSession [
 session := aSession
]
