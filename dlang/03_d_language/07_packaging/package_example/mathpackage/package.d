// package.d
// This file, which is found in the
// directory of the module, simply
// includes all of the 'imports'
// such that a user could
// do a 'import mathpackage' and
// bring everything in.

module mathpackage;
// Otherwise, a user can always
// 'selectively' choose which packages
// that they want.
import mathpackage.linear.vector;
import mathpackage.linear.matrix;
import mathpackage.general.funcs;
