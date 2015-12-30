pro CU_torus_plots

directory = 'D:/DATA/Apache Point Data/UT131107/'
Images_b = FILE_SEARCH(strcompress(Directory + 'Processed/' + '*b._CAL.fits'), count = n_images)
Images_r = FILE_SEARCH(strcompress(Directory + 'Processed/' + '*r._CAL.fits'), count = n_images)

lines_r = [6312.060, 6716.440, 6730.815] 
distance_extent_dawn = 7.3 ;Sample emisson out to a distance of this value (R_J) 
distance_extent_dusk = 7.3 ;Sample emisson out to a distance of this value (R_J)
image = MRDFITS(Images_r[0], 0, torus_header, /Dscale, /silent)
R_J_per_pixel = float(sxpar(torus_header, 'RJ_PER_P')) 
dawn_distance_array_r = findgen(distance_extent_dawn / R_J_per_pixel)
dusk_distance_array_r = findgen(distance_extent_dusk / R_J_per_pixel)

lines_b = [3726.04, 3728.80, 4068.60] 
distance_extent_dawn = 6.9 ;Sample emisson out to a distance of this value (R_J)
distance_extent_dusk = 6.9 ;Sample emisson out to a distance of this value (R_J)
image = MRDFITS(Images_b[0], 0, torus_header, /Dscale, /silent)
R_J_per_pixel = float(sxpar(torus_header, 'RJ_PER_P')) 
dawn_distance_array_b = findgen(distance_extent_dawn / R_J_per_pixel)
dusk_distance_array_b = findgen(distance_extent_dusk / R_J_per_pixel)

      ;==================================================Brightness Profiles===================================================================
      dusk_b = fltarr( n_elements(Images_b), n_elements(dusk_distance_array_b), n_elements(lines_b))
      dawn_b = fltarr( n_elements(Images_b), n_elements(dawn_distance_array_b), n_elements(lines_b) )
      for i = 0, n_elements(Images_b)-1 do begin
        image = MRDFITS(Images_b[i], 0, torus_header, /Dscale, /silent)   
        CML = float(sxpar(torus_header, 'CML_SYSI'))
        RJ_PER_Pixel = float(sxpar(torus_header, 'RJ_PER_P'))    
        distance_profiles = MRDFITS(Images_b[i], 2)
        dusk_distance_array_b = distance_profiles.dusk_distance_array_b    
        dawn_distance_array_b = distance_profiles.dawn_distance_array_b   
        dusk_line_profiles_b = distance_profiles.dusk_line_profiles
        dawn_line_profiles_b = distance_profiles.dawn_line_profiles     

        window, 0
        plot, R_J_per_pixel * dawn_distance_array_b, dawn_line_profiles_b[*,0], xrange = [5.,7.35], xstyle = 1, yrange = [0, 200], ytitle = 'Rayleighs', xtitle = 'dawn-side Distance (R!DJupiter!N)'  
        oplot, R_J_per_pixel * dawn_distance_array_b, dawn_line_profiles_b[*,1]
        oplot, R_J_per_pixel * dawn_distance_array_b, dawn_line_profiles_b[*,2]  
      
        window, 1
        plot, R_J_per_pixel * dusk_distance_array_b, dusk_line_profiles_b[*,0], xrange = [5.,7.35], xstyle = 1, yrange = [0, 200], ytitle = 'Rayleighs', xtitle = 'Dusk-side Distance (R!DJupiter!N)'  
        oplot, R_J_per_pixel * dusk_distance_array_b, dusk_line_profiles_b[*,1]
        oplot, R_J_per_pixel * dusk_distance_array_b, dusk_line_profiles_b[*,2]
        stop
        ;log them into an array for this day of observation:
        dawn_b[i, *, *] =  dawn_line_profiles_b    
        dusk_b[i, *, *] =  dusk_line_profiles_b     
      endfor
      dusk_r = fltarr( n_elements(Images_r), n_elements(dusk_distance_array_r), n_elements(lines_r) )
      dawn_r = fltarr( n_elements(Images_r), n_elements(dawn_distance_array_r), n_elements(lines_r) )
      for i = 0, n_elements(Images_r)-1 do begin
        image = MRDFITS(Images_r[i], 0, torus_header, /Dscale, /silent)   
        CML = float(sxpar(torus_header, 'CML_SYSI'))
        print, 'CML =', CML 
        RJ_PER_Pixel = float(sxpar(torus_header, 'RJ_PER_P'))    
        distance_profiles = MRDFITS(Images_r[i], 2)
        dusk_distance_array_r = distance_profiles.dusk_distance_array_r    
        dawn_distance_array_r = distance_profiles.dawn_distance_array_r 
        dusk_line_profiles_r = distance_profiles.dusk_line_profiles
        dawn_line_profiles_r = distance_profiles.dawn_line_profiles     

        window, 0
        plot, R_J_per_pixel * dawn_distance_array_r, dawn_line_profiles_r[*,0], xrange = [5.,7.35], xstyle = 1, yrange = [0, 200], ytitle = 'Rayleighs', xtitle = 'dawn-side Distance (R!DJupiter!N)'  
        oplot, R_J_per_pixel * dawn_distance_array_r, dawn_line_profiles_r[*,1]
        oplot, R_J_per_pixel * dawn_distance_array_r, dawn_line_profiles_r[*,2]  
      
        window, 1
        plot, R_J_per_pixel * dusk_distance_array_r, dusk_line_profiles_r[*,0], xrange = [5.,7.35], xstyle = 1, yrange = [0, 200], ytitle = 'Rayleighs', xtitle = 'Dusk-side Distance (R!DJupiter!N)'  
        oplot, R_J_per_pixel * dusk_distance_array_r, dusk_line_profiles_r[*,1]
        oplot, R_J_per_pixel * dusk_distance_array_r, dusk_line_profiles_r[*,2]
        
        ;log them into an array for this day of observation:
        dawn_r[i, *, *] =  dawn_line_profiles_r    
        dusk_r[i, *, *] =  dusk_line_profiles_r     
      endfor

      ;-------------------------------Dawn Plots-----------------------------------------
      print, 'Just using the first two frames in this plot'
      dawn_avg_by_2_r = mean(dawn_r[0:1,*,*], dimension = 1, /Nan)
      dawn_avg_by_2_b = mean(dawn_b[0:1,*,*], dimension = 1, /Nan)  
      print, 'Smoothing The Bright S+ Doublet by (Rj)', 5.*R_J_per_pixel
      print, 'Smoothing The Other Lines by (Rj)', 10.*R_J_per_pixel
      dawn_avg_by_2_b = Smooth(dawn_avg_by_2_b, [10, 0], /edge_mirror) 
      dawn_avg_by_2_r[*,0] = Smooth(dawn_avg_by_2_r[*,0], 10, /edge_mirror)
      dawn_avg_by_2_r[*,1:2] = Smooth(dawn_avg_by_2_r[*,1:2], [5, 0], /edge_mirror)
     
      cgPS_Open, filename=strcompress('C:\IDL\Io\Apache_Point_Programs\Dawn_Brightness_Profiles.eps'), /ENCAPSULATED, xsize = 8.5, ysize = 7.5
        !P.font=1
        device, SET_FONT = 'Helvetica Bold', /TT_FONT
        !p.charsize = 2.
        cgplot, R_J_per_pixel * dawn_distance_array_r, dawn_avg_by_2_r[*,0], xrange = [4.5,7.1], xstyle = 1, yrange = [0, 200], ytitle = 'Rayleighs', xtitle = 'Dawn-side Distance (R!DJupiter!N)', psym = 10, thick = 6., $
               color = cgcolor('Orange Red'), Title = cgSymbol('lambda') + '!DIII!N Longitudes = 208' + cgSymbol('deg') + ' to 216' + cgSymbol('deg')
        cgplot, R_J_per_pixel * dawn_distance_array_r, dawn_avg_by_2_r[*,1], /overplot, psym = 10, thick = 6., color = 'Red'
        cgplot, R_J_per_pixel * dawn_distance_array_r, dawn_avg_by_2_r[*,2], /overplot, psym = 10, thick = 6., color = 'Dark Red' 
        cgplot, R_J_per_pixel * dawn_distance_array_b, dawn_avg_by_2_b[*,0], /overplot, psym = 10, thick = 6., color = 'Violet' 
        cgplot, R_J_per_pixel * dawn_distance_array_b, dawn_avg_by_2_b[*,1], /overplot, psym = 10, thick = 6., color = 'Blue Violet' 
        cgplot, R_J_per_pixel * dawn_distance_array_b, dawn_avg_by_2_b[*,2], /overplot, psym = 10, thick = 6., color = 'Dodger blue' 
        
        cgText, 6.5, 180, 'SII 6731'+cgSymbol('Angstrom'), color = cgcolor('Dark Red')  
        cgText, 6.5, 165, 'SII 6716'+cgSymbol('Angstrom'), color = cgcolor('Red') 
        cgText, 6.5, 150, 'SIII 6312'+cgSymbol('Angstrom'), color = cgcolor('Orange Red') 
        cgText, 6.5, 135, 'SII 4069'+cgSymbol('Angstrom'), color = cgcolor('Dodger blue')
        cgText, 6.5, 120, 'OII 3729'+cgSymbol('Angstrom'), color = cgcolor('Blue Violet') 
        cgText, 6.5, 105, 'OII 3726'+cgSymbol('Angstrom'), color = cgcolor('Violet')
      cgPS_Close 
      set_plot,'WIN'

      ;--------------------------------Dusk PLot-------------------------------------------
      print, 'Just using the first two frames in this plot'
      dusk_avg_by_2_r = mean(dusk_r[0:1,*,*], dimension = 1, /Nan)  
      dusk_avg_by_2_b = mean(dusk_b[0:1,*,*], dimension = 1, /Nan)  
      print, 'Smoothing The Bright S+ Doublet by (Rj)', 5.*R_J_per_pixel
      print, 'Smoothing The Other Lines by (Rj)', 10.*R_J_per_pixel
      dusk_avg_by_2_b = Smooth(dusk_avg_by_2_b, [10, 0], /edge_mirror) 
      dusk_avg_by_2_r[*,0] = Smooth(dusk_avg_by_2_r[*,0], 10, /edge_mirror)
      dusk_avg_by_2_r[*,1:2] = Smooth(dusk_avg_by_2_r[*,1:2], [5, 0], /edge_mirror) ;smooth by 5. 
      
      cgPS_Open, filename=strcompress('C:\IDL\Io\Apache_Point_Programs\Dusk_Brightness_Profiles.eps'), /ENCAPSULATED, xsize = 8.5, ysize = 7.5
        !P.font=1
        device, SET_FONT = 'Helvetica Bold', /TT_FONT
        !p.charsize = 2.
        cgplot, R_J_per_pixel * Dusk_distance_array_r, dusk_avg_by_2_r[*,0], xrange = [4.5,7.1], xstyle = 1, yrange = [0, 200], ytitle = 'Rayleighs', xtitle = 'Dusk-side Distance (R!DJupiter!N)', psym = 10, thick = 6., $
               color = cgcolor('Orange Red'), Title = cgSymbol('lambda') + '!DIII!N Longitudes = 28' + cgSymbol('deg') + ' to 36' + cgSymbol('deg')
        cgplot, R_J_per_pixel * Dusk_distance_array_r, dusk_avg_by_2_r[*,1], /overplot, psym = 10, thick = 6., color = 'Red'
        cgplot, R_J_per_pixel * Dusk_distance_array_r, dusk_avg_by_2_r[*,2], /overplot, psym = 10, thick = 6., color = 'Dark Red' 
        cgplot, R_J_per_pixel * Dusk_distance_array_b, dusk_avg_by_2_b[*,0], /overplot, psym = 10, thick = 6., color = 'Violet' 
        cgplot, R_J_per_pixel * Dusk_distance_array_b, dusk_avg_by_2_b[*,1], /overplot, psym = 10, thick = 6., color = 'Blue Violet' 
        cgplot, R_J_per_pixel * Dusk_distance_array_b, dusk_avg_by_2_b[*,2], /overplot, psym = 10, thick = 6., color = 'Dodger blue' 
        
        cgText, 6.5, 180, 'SII 6731'+cgSymbol('Angstrom'), color = cgcolor('Dark Red')  
        cgText, 6.5, 165, 'SII 6716'+cgSymbol('Angstrom'), color = cgcolor('Red') 
        cgText, 6.5, 150, 'SIII 6312'+cgSymbol('Angstrom'), color = cgcolor('Orange Red') 
        cgText, 6.5, 135, 'SII 4069'+cgSymbol('Angstrom'), color = cgcolor('Dodger blue')
        cgText, 6.5, 120, 'OII 3729'+cgSymbol('Angstrom'), color = cgcolor('Blue Violet') 
        cgText, 6.5, 105, 'OII 3726'+cgSymbol('Angstrom'), color = cgcolor('Violet')
      cgPS_Close 
      set_plot,'WIN'
      stop
 end     