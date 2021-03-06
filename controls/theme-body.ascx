<%--
  This is the main part of our Themes
  It's in a separate file so it can be shared

  Note that it's included using the include-syntax, not as a web-control. 
  This is important, because otherwise Dnn won't detect the panes in here
--%>

<%@ Control language="C#" AutoEventWireup="false" Explicit="True" Inherits="DotNetNuke.UI.Skins.Skin" %>
<%@ Register TagPrefix="dnn" TagName="LOGIN" Src="~/Admin/Skins/Login.ascx" %>
<%@ Register TagPrefix="dnn" Namespace="DotNetNuke.Web.DDRMenu.TemplateEngine" Assembly="DotNetNuke.Web.DDRMenu" %>
<%@ Register TagPrefix="dnn" TagName="MENU" src="~/DesktopModules/DDRMenu/Menu.ascx" %>
<%@ Register TagPrefix="dnn" Namespace="DotNetNuke.Web.Client.ClientResourceManagement" Assembly="DotNetNuke.Web.Client" %>
<%@ Register TagPrefix="ToSic" TagName="LanguageNavigation" src="LanguageNavigation.ascx" %>
<%@ Register TagPrefix="dnn" TagName="BREADCRUMB" Src="~/Admin/Skins/BreadCrumb.ascx" %>
<%-- Change the page title to contain the breadcrumbi in an SEO optimized way --%>
<%@ Register TagPrefix="tosic" TagName="PageTitle" src="optimize-page-title.ascx" %>
<tosic:PageTitle runat="server" />

<%-- Activate Quick-Edit in empty pages if 2sxc is installed
  more infos on 2sxc quick-edit: https://2sxc.org/en/blog/post/quick-edit-2-add-move-delete-modules-in-preview-touch-capable-for-dnn
--%>
<%@ Register TagPrefix="tosic" TagName="SxcQuickEdit" src="2sxc-quickedit.ascx" %>
<tosic:SxcQuickEdit runat="server" />

<%-- This has all common 2sxc services and GetScopedService(...)  --%>
<%@ Import Namespace="ToSic.Sxc.Services" %>
<script runat="server">
  public int ToSafeInt(object value) {
    return this.GetScopedService<IConvertService>().ToInt(value, 0);
  }
</script>

<%-- This has all common 2sxc services and GetScopedService(...)  --%>
<%@ Import Namespace="ToSic.Sxc.Services" %>
<%-- This namespace provides IDynamicCode --%>
<%@ Import Namespace="ToSic.Sxc.Code" %>
<script runat="server">
  // Get the Dynamic Code of this Site = OfSite() and keep for re-use
  protected IDynamicCode SiteDynCode { 
    get { return _sdc ?? (_sdc = this.GetScopedService<IDynamicCodeService>().OfSite()); } 
  }
  private IDynamicCode _sdc;

  // Shorthand to Get a service using the SiteDynCode 
  // this will add context to services which need it
  protected T GetService<T>() {
    return SiteDynCode.GetService<T>();
  }

  // Get the PageToolbar to show somewhere using <%= PageToolbar() %>
  private object PageToolbar() {
    // Use GetService of the SiteDynCode so it can give the service more context
    var toolbarSvc = GetService<IToolbarService>();
    var page = SiteDynCode.CmsContext.Page;
    var pageTlb = toolbarSvc.Metadata(page);
    return SiteDynCode.Edit.Toolbar(pageTlb);
  }

  // Apply OpenGraph settings of the page
  private void SetOpenGraph() {
    // Use GetService of the SiteDynCode so it can give the service more context
    var pageSvc = GetService<IPageService>();
    var pageMd = SiteDynCode.CmsContext.Page.Metadata as dynamic;
    pageSvc.AddOpenGraph("og:type", pageMd.OgType);
    pageSvc.AddOpenGraph("og:title", pageMd.OgTitle);

    // Activate fancybox on all pages
    pageSvc.Activate("fancybox4");
  }
</script>


<%@ Import Namespace="System.Linq" %>

<%-- end --%>

<a class="visually-hidden-focusable" rel="nofollow" href="#to-shine-page-main"><%= LocalizeString("SkipLink.MainContent") %></a>
<header id="to-shine-page-header">
  <div class="container d-flex justify-content-between align-items-center py-3">			
    <a class="logo" href="<%= DotNetNuke.Common.Globals.NavigateURL(PortalController.GetCurrentPortalSettings().HomeTabId) %>" title="2shine DNN BS5 2sxc (change this in the theme-body.ascx)">			
      <img alt="Logo" class="img-fluid" src="<%=SkinPath%>images/logo.svg">
    </a>
    <%= PageToolbar() %>
    <div class="to-shine-mobile-hamburger" data-bs-toggle="offcanvas" data-bs-target="#offcanvasStart" aria-controls="offcanvasStart" title="Menu">
      <div>
        <span></span>
        <span></span>
        <span></span>
      </div>
    </div>
  <div class="offcanvas offcanvas-start" tabindex="-1" id="offcanvasStart" aria-labelledby="offcanvasTopLabel">
    <div class="offcanvas-header">
      <a class="logo" href="<%= DotNetNuke.Common.Globals.NavigateURL(PortalController.GetCurrentPortalSettings().HomeTabId) %>" title="2shine DNN BS5 2sxc  (change this in the theme-body.ascx)">			
        <img alt="Logo" class="img-fluid" src="<%#SkinPath%>images/logo.svg">
      </a>
      <button type="button" class="btn-close text-reset" data-bs-dismiss="offcanvas" aria-label="Close"></button>
    </div>
    <div class="offcanvas-body bg-primary px-0">
      <dnn:MENU MenuStyle="nav/main-mobile" NodeSelector="*,0,6" runat="server" />
      <ToSic:languagenavigation runat="server" Languages="de-DE:DE,en-US:EN,fr-FR:FR,it-IT:IT" />
    </div>
  </div>
    
    <nav id="nav-desktop" class="d-none d-lg-flex flex-column align-items-end">
      <div class="d-none d-lg-flex">
        <ToSic:languagenavigation runat="server" Languages="de-DE:DE,en-US:EN,fr-FR:FR,it-IT:IT" />
        <%
        if(DotNetNuke.Security.PortalSecurity.IsInRoles(PortalSettings.AdministratorRoleName)) {
        %>
          <a href="?ctl=logoff" Title="Logoff" class="to-shine-login" target="_self">
            <svg version="1.1" id="Ebene_1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px"
              viewBox="0 0 12.2 14.5" style="enable-background:new 0 0 12.2 14.5;" xml:space="preserve">
            <g>
              <path d="M12.2,8.8v4.4c0,0.7-0.6,1.3-1.3,1.3H1.3c-0.7,0-1.3-0.6-1.3-1.3V8.8c0-0.7,0.6-1.3,1.3-1.3H2V4.7c0-2.3,1.8-4.2,4.1-4.2
                s4.2,1.9,4.2,4.2v0.4c0,0.4-0.3,0.7-0.7,0.7H8.8c-0.4,0-0.7-0.3-0.7-0.7V4.7c0-1.1-0.9-2-2-2c-1.1,0-1.9,0.9-1.9,2v2.8h6.8
                C11.7,7.5,12.2,8.1,12.2,8.8z"/>
            </g>
            </svg>
          </a>
        <%
        } else {
        %>        
          <a href="?ctl=login" Title="Login" class="to-shine-login" target="_self">
            <svg version="1.1" id="Lock" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px"
              viewBox="0 0 12.2 14" style="enable-background:new 0 0 12.2 14;" xml:space="preserve">
              <g>
                <path d="M12.2,7.4v5.2c0,0.7-0.6,1.3-1.3,1.3H1.3C0.6,14,0,13.4,0,12.7V7.4c0-0.7,0.6-1.3,1.3-1.3H2v-2C2,1.9,3.8,0,6.1,0
                  s4.2,1.9,4.2,4.2v2h0.7C11.7,6.1,12.2,6.7,12.2,7.4z M8.1,4.2c0-1.1-0.9-2-2-2s-2,0.9-2,2v2h3.9V4.2z"/>
              </g>
            </svg>
          </a>
        <%
        }
        %>        
      </div>
      <dnn:MENU MenuStyle="nav/main" NodeSelector="*,0,1" runat="server" />
    </nav>
  </div>
</header>
<div id="to-shine-page-header-pane" class="container-xxl px-0 <%= (HeaderPane.Attributes["class"] ?? "").Contains("DNNEmptyPane") ? "to-shine-header-pane-empty" : "" %>">
  <div id="HeaderPane" runat="server" containertype="G" containername="2shine BS5" containersrc="fullwidthWithoutPadding.ascx"></div>
</div>
<main id="to-shine-page-main">
  <div class="to-shine-page-breadcrumb" aria-label="breadcrumb">
    <div class="container py-2">
      <a class="to-shine-page-breadcrumb-link to-shine-page-breadcrumb-home" aria-current="page" href="<%= DotNetNuke.Common.Globals.NavigateURL(PortalSettings.HomeTabId) %>"><%= LocalizeString("Home.Text") %></a>
      <span>&nbsp;&rsaquo;&nbsp;</span><span class="to-shine-page-breadcrumb-trigger display-inline display-md-none"><a aria-current="page">...</a></span>
      <dnn:BREADCRUMB runat="server" aria-current="page" Separator="<span>&nbsp;&rsaquo;&nbsp;</span>" CssClass="to-shine-page-breadcrumb-link" RootLevel="0" />
    </div>		
  </div>
  <% 
  if(ShowSidebarNavigation) {
  %>
  <div class="container">
    <div class="row">
      <div class="col-xs-12 col-lg-9 order-lg-2 ly-col-contentpane">
  <%
  }
  %>
        <div id="ContentPane" runat="server" containertype="G" containername="2shine BS5" containersrc="default.ascx"></div>
  <% 
  if(ShowSidebarNavigation) {
  %>        
      </div>
      <div class="col-xs-12 col-lg-3 order-lg-1 ly-col-leftpane">
        <div id="nav-sub" class="d-none d-sm-block">  
          <dnn:MENU MenuStyle="nav/sub" NodeSelector="+0,0,2" runat="server" />
        </div>
      </div>
    </div>
  </div>
  <%
  }
  %>
  <a id="to-shine-to-top" href="#" title="Nach oben" rel="nofollow">
    <svg xmlns="http://www.w3.org/2000/svg" width="19.032" height="20.034" viewBox="0 0 19.032 20.034">
      <g id="Group_2" data-name="Group 2" transform="translate(-1055.984 -551.276)">
        <path id="Path_2" data-name="Path 2" d="M8.1,16.2,0,8.1,8.1,0" transform="translate(1073.602 552.69) rotate(90)" fill="none" stroke="#fff" stroke-linecap="round" stroke-width="2"/>
        <line id="Line_1" data-name="Line 1" y2="17.599" transform="translate(1065.481 552.711)" fill="none" stroke="#fff" stroke-linecap="round" stroke-width="2"/>
      </g>
    </svg>
  </a>
</main>
<footer id="to-shine-page-footer">
  <asp:Panel id="ModulesInFooter" runat="server" Visible="<%# ShowModulesInFooter %>">
    <%@ Import Namespace="ToSic.Sxc.Dnn" %>
    <%@ Import Namespace="ToSic.Sxc.Services" %>
    <%= this.GetScopedService<IRenderService>().Module(5279, 11228) %>
    <hr>
    <%= this.GetScopedService<IRenderService>().Module(5279, 11229) %>
  </asp:Panel>

  <div class="container py-4 d-flex justify-content-md-between flex-column flex-md-row text-white">
    <ul class="to-shine-footer-address" itemscope itemtype="http://schema.org/LocalBusiness">
      <li>
        <strong itemprop="name">2shine DNN BS5 2sxc </strong>
      </li>
      <li>
        <span itemprop="address" itemscope itemtype="http://schema.org/PostalAddress">
          <span itemprop="streetAddress">Shine Road 77</span>,
          <span itemprop="postalCode">50355</span>
          <span itemprop="addressLocality">Shine City</span>,
          <span itemprop="addressCountry">Shine Country</span>
        </span>
      </li>
        <li><a href="tel:+41817506777">+41 81 750 67 77</a></li>
      <li>
        <span data-madr1="shine" data-madr2="example" data-madr3="com" data-linktext=""></span>
      </li>
    </ul>
    <div class="to-shine-footer-imprint">
        <dnn:login id="DnnLogin" cssclass="to-shine-page-login d-none d-lg-inline-flex" rel="nofollow" runat="server" />
        <%-- 
          Terms and Privacy Links are set in "Site Settings" > "Site Behavior"
        --%>
        <a href="<%= DotNetNuke.Common.Globals.NavigateURL(PortalController.GetCurrentPortalSettings().PrivacyTabId) %>" title="<%= LocalizeString("Imprint.Text") %>"><%= LocalizeString("Imprint.Text") %></a> | 
        <a href="<%= DotNetNuke.Common.Globals.NavigateURL(PortalController.GetCurrentPortalSettings().TermsTabId) %>" title="<%= LocalizeString("Privacy.Text") %>"><%= LocalizeString("Privacy.Text") %></a>
    </div>
  </div>
</footer>

<!-- include files -->
<dnn:DnnCssInclude runat="server" FilePath="dist/theme.min.css" Priority="100" PathNameAlias="SkinPath" />
<dnn:DnnJsInclude runat="server" FilePath="dist/lib/bootstrap.bundle.min.js" ForceProvider="DnnFormBottomProvider" Priority="100" PathNameAlias="SkinPath"  />
<dnn:DnnJsInclude runat="server" FilePath="dist/theme.min.js" ForceProvider="DnnFormBottomProvider" Priority="130" PathNameAlias="SkinPath" />
<script runat="server">
  
  protected override void OnLoad(EventArgs e)
  {
    base.OnLoad(e);
    AttachCustomHeader("<meta name='viewport' content='width=device-width, initial-scale=1, shrink-to-fit=no' />");

    SetOpenGraph();
    // Set various FavIcon and Icon headers according to best practices
    // The next line is disabled by default, because it requires RazorBlade to be installed.
    // How to install RazorBlade 3: https://azing.org/dnn-community/r/zbh8JC5T
    // How to create best-practice FavIcons: https://azing.org/dnn-community/r/UhgWJbxh
    // ToSic.Razor.Blade.HtmlPage.AddIconSet(SkinPath + "favicon.png");
  }
  protected void AttachExternalCSS(string CSSPath) { AttachCustomHeader("<link type='text/css' rel='stylesheet' href='" + CSSPath + "' />"); }
  protected void AttachExternalJS(string JSPath) { AttachCustomHeader("<script type='text/javascript' src='" + JSPath + "'></scr" + "ipt>"); }
  protected void AttachCustomHeader(string CustomHeader) { HtmlHead HtmlHead = (HtmlHead)Page.FindControl("Head"); if ((HtmlHead != null)) { HtmlHead.Controls.Add(new LiteralControl(CustomHeader));	}	}

  protected string LocalizeString(string key)
  {
      return Localization.GetString(key, Localization.GetResourceFile(this, System.IO.Path.GetFileName(this.AppRelativeVirtualPath)));
  }
</script>


MDEntityId: <%= SiteDynCode.CmsContext.Page.Metadata.EntityId %>
<br>
Typeof: <%= this.GetType().BaseType.BaseType %>
<hr>
Toolbar: <%= SiteDynCode.Edit.Enabled %>
<hr>
Page: <%# SiteDynCode.CmsContext.Page.Id %> / <%# SiteDynCode.CmsContext.Page.Url %> / <%= SiteDynCode.CmsContext.Page.Metadata.EntityId %> 
 / Icon: <%# (SiteDynCode.CmsContext.Page.Metadata as dynamic).Icon %>
