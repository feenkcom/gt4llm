Class {
	#name : #GtLChatCompaction,
	#superclass : #GtLMarkdown,
	#category : #'Gt4LlmCore-Formats'
}

{ #category : #'as yet unclassified' }
GtLChatCompaction >> contentDescription [
	<magritteDescription>
	
	^ super contentDescription
		comment: 'The Chat Compaction in the form of a Markdown format with a few extensions.' , 
		String cr, self commentForSmalltalk,
		String cr, self commentForSmaCC
]
