## Get Our Code Repositories

!!crystallib.git.pull url:'https://github.com/ourworld-tsc/ourworld_books/tree/development/content' name:'owb'
!!crystallib.git.pull url:'https://github.com/threefoldfoundation/books/tree/main/books' name:'books'

!!crystallib.git.params.multibranch name:'books'

//needs to include the content, not as macro
!!include path:'run_include.md'

!!crystallib.git.link gitsource:owb
gitdest:books
source:'feasibility_study/Capabilities'
dest:'feasibility_study_internet/src/capabilities2'

<!-- is same as above -->

!!crystallib.git.link
source:'https://github.com/ourworld-tsc/ourworld_books/tree/development/content/feasibility_study/Capabilities'
dest:'https://github.com/threefoldfoundation/books/tree/main/books/feasibility_study_internet/src/capabilities'

<!-- if name not specified, will use the name of the directory -->

!!threefold.books.add
path:'https://github.com/threefoldfoundation/books/tree/main/books/technology/src'
name:technology

<!-- path can be a path or url, if gitsource specified will append to the git it points too -->

!!threefold.books.add
gitsource:'books'
path:'technology/src'
name:technology2

<!-- export to a chosen path or url -->

!!threefold.books.mdbook_export name:feasibility_study_internet path:'/tmp/exportedbook'

<!--!!books.export name:myname url:'https://github.com/threefoldfoundation/home'-->

<!-- export all books -->
<!-- //!!books.mdbook_export name:* -->

!!threefold.books.mdbook_develop name:feasibility_study_internet

<!-- !!publishtools.publish server:'ourserver.com' -->
