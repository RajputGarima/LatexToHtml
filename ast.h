#include<stdio.h>
#include<stdlib.h>
#include<stdarg.h>

struct treenode{
	char type;
	char* name;
	char* value;
	int count;
	struct treenode** children;
};




struct node{
	struct treenode** ptr; 
	struct node* next;
};

char* checkGraphics(int a, int b){
	if(!a && !b){
	static char * str="Error : package graphicx / graphics not included";	
	return str;	
	}
	return NULL;
}

void enqueue(struct node** front, struct node** rear, struct treenode** data){
	struct node* temp= (struct node*)malloc(sizeof(struct node)); 
	temp->ptr=data;
	temp->next=NULL;
		if(*front==NULL && *rear==NULL){
			*front=temp;
			*rear=temp;
			return;
		}
		(*rear)->next=temp;
	 	*rear=temp;			
}



struct treenode** dequeue( struct node** front, struct node** rear ){
	if( *front==NULL)
		return NULL;
	struct node* temp= *front;
	struct treenode** res= temp->ptr;
	if(*front==*rear){
		*front=NULL;
		*rear=NULL;temp=NULL;
		free(temp);
		temp=NULL;
		return res;
	}
	*front=temp->next;
	free(temp);
	temp=NULL;
	return res;	
}


void printdata(struct treenode* ptr, FILE* html){
		printf("type : %c, name: %s\n", ptr->type, ptr->name );
		if(ptr->value)
		 fprintf(html, "%s", ptr->value);
		if(ptr->count!=-1)
		fprintf(html, "%d", ptr->count);
}


struct treenode ** returnChild(struct treenode* children[],int num,...){
int i;
 	va_list ap;
 
    // va_start must be called before accessing
    // variable argument list
    va_start(ap, num);
 
    // Now arguments can be accessed one by one
    // using va_arg macro. Initialize min as first
    // argument in list
    struct treenode* node = va_arg(ap, struct treenode*);
    //printdata(node);
    children[0] = node;
 
    // traverse rest of the arguments to find out minimum
    for (i = 2; i <= num; i++){
	node = va_arg(ap,struct treenode*);
	children[i-1] = node;
        //printdata(node);
	}
	children[i-1] = NULL;
    // va_end should be executed before the function
    // returns whenever va_start has been previously
    // used in that function
    va_end(ap);
	return children;
}


void levelorder(struct treenode* root){
	if(root==NULL)
		return;

	struct node* front= NULL, *rear=NULL;
	//printdata(root);
	enqueue(&front, &rear , root->children);
	while(front!=NULL){
		struct treenode** temp= dequeue(&front, &rear);
		int i=0;
		while( temp && *( temp+i) ){
			//printdata(*(temp+i));
			if( (*(temp+i) )->children ) 
			enqueue(&front, &rear, (*(temp+i))->children);
			i++;
		}
	}
}

void dfs(struct treenode* root, FILE* html){
	if(root==NULL){
	 return;
	}
	int i=0;
	printdata(root, html);

	while( root->children && *((root->children)+i) ){
		dfs( *((root->children) +i),  html );
		i++;
	}
}

struct treenode * addnode(char t,char *name,char *value,int count , struct treenode **children ){
	struct treenode *tnode = NULL;
	
	if( ( tnode = (struct treenode*)malloc( sizeof(struct treenode) ) ) == NULL ) {
		return NULL;
	}
	tnode -> type = t;
	tnode -> name = name;
	tnode -> value = value;
	tnode->count=count;
	tnode -> children = children;
	return tnode;
}


/*void toS(char str[], int count){
	int i=0, j, len=0, c;
	while(count!=0){
		 c = count%10;
printf("fkrnm");
		str[i]=c;
		count=count/10;
		i++;
	}
	str[i]='\0';

	i=0;
	while(str[i])
		len++;
	j=len-1;
	i=0;
	while(i<j){
		char temp= str[i];
		str[i]= str[j];
		str[j]= temp;
		i++;
		j--;
	}
	
}*/

